module Referrer
  class Session < ActiveRecord::Base
    belongs_to :user
    has_many :sources

    validates_presence_of :user, :active_until

    before_validation :set_active_until

    def active_seconds
      (active_until - Time.now).to_i
    end

    private

    def set_active_until
      self.active_until = Time.now + Referrer.session_duration
    end
  end
end
