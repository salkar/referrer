module Referrer
  class Session < ActiveRecord::Base
    belongs_to :user
    has_many :sources
  end
end
