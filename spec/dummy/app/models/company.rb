class Company < ActiveRecord::Base
  include Referrer::OwnerModelAdditions
end
