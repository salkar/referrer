class User < ActiveRecord::Base
  include Referrer::OwnerModelAdditions
  has_many :posts
end
