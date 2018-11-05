Rails.application.routes.draw do
  root 'stream_packages#index'
  resources :stream_packages
  resources :channels
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
