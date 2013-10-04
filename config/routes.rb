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

  scope :session do
    get 'login', :to => 'sessions#new', :as => :new_session
    get 'logout', :to => 'sessions#destroy', :as => :destroy_session
  end

  scope :auth do
    post 'identity/register', :to => 'users#create', :as => :register_user
    match ':provider/callback', :to => 'sessions#create', :as => :create_session, :via => [:get, :post]
    get 'failure', :to => 'sessions#failure'
  end

  get 'register', :to => 'users#new', :as => :registration

end
