Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "dogs#index"
  get '/dog', to: 'dogs#show'
  get '/dogs', to: 'dogs#index'
  put '/dog', to: 'dogs#update'
end
