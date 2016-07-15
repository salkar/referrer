Referrer::Engine.routes.draw do
  resources :users, only: :create
  resources :sessions, only: :create
  resources :sources, only: [] do
    collection do
      post :mass_create
    end
  end
end
