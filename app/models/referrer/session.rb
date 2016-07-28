module Referrer
  class Session < ActiveRecord::Base
    belongs_to :user
    has_many :sources

    validates_presence_of :user, :active_until

    before_validation :set_active_period

    scope :active_at, -> (time) { where('active_from <= :time AND active_until >= :time', {time: time}) }

    def active_seconds
      (active_until - Time.now).to_i
    end

    def source_at(time)
      sources.prioritized.where('active_from <= ?', time).last
    end

    private

    def set_active_period
      self.active_from = Time.now unless active_from
      self.active_until = Time.now + Referrer.session_duration unless active_until
    end
  end
end
