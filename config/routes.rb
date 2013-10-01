FissionApp::Application.routes.draw do

  root 'dashboard#index'

  resources :accounts do
    resources :request_tokens
    resources :api_tokens
    resources :account_permissions, :path => :permissions
    resources :account_emails, :path => :emails
    resources :account_users, :path => :users
  end

  resources :users do
    resources :request_tokens
    resources :api_tokens
    resources :user_permssions, :path => :permissions
    resources :user_emails, :path => :emails
    resources :account_users, :path => :accounts
  end

  resources :jobs

  namespace :admin do
    resources :permissions
  end

  get '/login', :to => 'sessions#new', :as => :login
  get '/auth/:provider/callback', :to => 'sessions#create_omni', :as => :login_via
  post '/login', :to => 'sessions#create', :as => :do_login

end
