module Referrer
  class Source < ActiveRecord::Base
    belongs_to :session

    validates_presence_of :entry_point, :utm_source, :utm_campaign, :utm_medium, :utm_content, :utm_term

    before_validation :generate_markup

    private

    def generate_markup

    end
  end
end
