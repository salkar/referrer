module Referrer
  class User < ActiveRecord::Base
    has_many :linked_object
    has_many :sessions

    validates :token, presence: true

    before_validation :generate_token, on: :create

    private

    def generate_token
      self.token = SecureRandom.hex(5)
    end
  end
end
