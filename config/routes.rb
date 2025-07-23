# config/routes.rb
Rails.application.routes.draw do
  # Root path
  # root "users#new"
  root "sessions#new"

  # UI Routes
  get "sessions/new"
  post "sessions/create"
  get "users/new"


  get 'users/books', to: 'users#books'


  # Authentication Routes (UI)
  get "signup", to: "users#new"
  post "signup", to: "users#create"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  # delete "logout", to: "sessions#destroy"
  delete '/api/logout', to: 'api/sessions#destroy'


  
  # Book routes (UI)
  get '/books', to: 'books#index'
  post '/books', to: 'books#create'
  post '/books/:id', to: 'books#update'
  get '/books/:id', to: 'books#show'
  get '/books/new', to: 'books#new'
  get '/books/:id/edit', to: 'books#edit', as: 'edit_book'
  get '/all_books', to: 'books#index'
  delete '/books/:id', to: 'books#destroy', as: 'delete_book'

  get '/profile', to: 'users#show_profile'


 


  #  API routes
  namespace :api do
    post "signup", to: "users#create"
    get "signup", to: "users#new"
    get "users", to: "users#index"

    #  Add these lines to support POST /api/sessions and DELETE /api/logout
    post "sessions", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    post "login", to: "sessions#create"

    get '/profile', to: 'users#show_profile'
    get 'users/presigned_url', to: 'users#presigned_url'
  

  
    resources :users do
      resources :books, only: [:index, :show, :create, :update, :destroy]
    # resources :users, only:[:create, :index]
    end
end
end