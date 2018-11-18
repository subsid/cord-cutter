Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'login', to: redirect('/auth/google_oauth2'), as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signin', to: 'signin#show', as: 'signin'
  get 'home', to: 'home#show', as: 'home'
  post 'home', to: 'home#show'

  root to: "home#show"
# root should be set to user home page
  # root 'stream_packages#index'
  resources :stream_packages
  resources :channels
end
