module Referrer
  module OwnerModelAdditions
    extend ActiveSupport::Concern

    included do
      has_many :referrer_users_main_app_users, class_name: 'Referrer::UsersMainAppUser', as: :main_app_user

      def referrer_users
        referrer_users_main_app_users.includes(:user).map{|relation| relation.user}
      end

      def referrer_sources
        Referrer::Source.where(
            session_id: Referrer::Session.where(user_id: referrer_users_main_app_users.pluck(:user_id)).pluck(:id))
      end

      def referrer_first_source
        referrer_sources.first
      end

      def referrer_priority_source
        referrer_sources.priority.last
      end

      def referrer_last_source
        referrer_sources.last
      end

      def referrer_markups
        Hash[{first: referrer_first_source, priority: referrer_priority_source,
         last: referrer_last_source}.map{|k, v| [k, v.try(:to_markup)]}]
      end
    end
  end
end
