module Referrer
  class User < ActiveRecord::Base
    has_many :sessions
    has_many :users_main_app_users

    validates :token, presence: true

    before_validation :generate_token, on: :create

    def link_with(obj)
      users_main_app_users.create(main_app_user: obj)
    end

    def linked_with?(obj)
      users_main_app_users.where(main_app_user: obj).present?
    end

    def linked_objects
      users_main_app_users.includes(:main_app_user).map{|relation| relation.main_app_user}
    end

    private

    def generate_token
      self.token = SecureRandom.hex(5)
    end
  end
end
