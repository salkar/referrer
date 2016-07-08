module Referrer
  class UsersMainAppUser < ActiveRecord::Base
    belongs_to :main_app_user, polymorphic: true
    belongs_to :user
  end
end
