Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'login', to: redirect('/auth/google_oauth2'), as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signin', to: 'signin#show', as: 'signin'
  get 'home', to: 'home#show', as: 'home'
  post 'home', to: 'home#show'
  get 'user/input', to: 'user#input'
  post 'user/recommendation', to: 'user#recommendation', as: 'recommendation'

  root to: redirect('user/input')
  resources :stream_packages
  resources :channels
end
