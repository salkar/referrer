module Referrer
  module ControllerAdditions
    extend ActiveSupport::Concern

    included do
      before_action :link_referrer_user_to_app_user

      def link_referrer_user_to_app_user
        current_object = send(Referrer.current_user_method_name)
        if current_object && referrer_user && referrer_user.main_app_user.blank?
          referrer_user.main_app_user = current_object
          referrer_user.save
        end
      end

      def referrer_user
        @referrer ||= begin
          id, token = *(cookies[:referrer_user] || '').split(' ')
          Referrer::User.where(id: id, token: token).first
        end
      end
    end
  end
end
