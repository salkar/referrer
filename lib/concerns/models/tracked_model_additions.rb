module Referrer
  module TrackedModelAdditions
    extend ActiveSupport::Concern

    included do
      has_many :tracked_relations, as: :trackable, class_name: 'Referrer::SourcesTrackedObject'

      def referrer_link_with(r_user, linked_at: nil)
        tracked_relations.create(user: r_user, linked_at: linked_at)
      end

      def referrer_link_with!(r_user, linked_at: nil)
        tracked_relations.create!(user: r_user, linked_at: linked_at)
      end
    end
  end
end
