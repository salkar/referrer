module Referrer
  module TrackedModelAdditions
    extend ActiveSupport::Concern

    included do
      has_one :tracked_relation, as: :trackable, class_name: 'Referrer::SourcesTrackedObject'

      def referrer_link_with(r_user, linked_at: nil)
        create_tracked_relation(user: r_user, linked_at: linked_at)
      end

      def referrer_link_with!(r_user, linked_at: nil)
        create_tracked_relation!(user: r_user, linked_at: linked_at)
      end

      def referrer_markup
        tracked_relation.try(:source).try(:to_markup).try(:symbolize_keys!)
      end
    end
  end
end
