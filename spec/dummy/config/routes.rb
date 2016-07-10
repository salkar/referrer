Rails.application.routes.draw do
  resources :posts, only: [:index, :new, :create]
  mount Referrer::Engine => '/referrer'

  root to: 'welcome#index'
end
