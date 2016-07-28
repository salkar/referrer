module Referrer
  class SourcesTrackedObject < ActiveRecord::Base
    belongs_to :trackable, polymorphic: true
    belongs_to :user
    belongs_to :source

    validates_presence_of :trackable, :user, :linked_at
    before_validation :set_fields, on: :create

    private

    def set_fields
      self.linked_at = Time.now unless linked_at
      self.source = user.try(:source_at, linked_at) if linked_at
    end
  end
end
