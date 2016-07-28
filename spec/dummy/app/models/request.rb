class Request < ActiveRecord::Base
  include Referrer::TrackedModelAdditions
end
