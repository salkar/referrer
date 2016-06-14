Rails.application.routes.draw do

  mount Referrer::Engine => "/referrer"
end
