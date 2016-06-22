module Referrer
  class User < ActiveRecord::Base
    belongs_to :linked_object, polymorphic: true
    has_many :sessions
  end
end
