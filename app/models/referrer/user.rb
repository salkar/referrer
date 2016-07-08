module Referrer
  class User < ActiveRecord::Base
    has_many :linked_object
    has_many :sessions
    belongs_to :main_app_user, polymorphic: true

    validates :token, presence: true

    before_validation :generate_token, on: :create

    private

    def generate_token
      self.token = SecureRandom.hex(5)
    end
  end
end
