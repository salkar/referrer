Referrer::Engine.routes.draw do
  resources :users, only: :create
  resources :sessions, only: :create
  resources :sources, only: :create
end
