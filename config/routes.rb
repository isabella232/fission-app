FissionApp::Application.routes.draw do

  root 'dashboard#index'

  resources :accounts do
    resources :users
    resource :owner, :controller => :users_controller
  end

  resources :users do
    resources :accounts
    resource :base_account, :controller => :accounts_controller
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
    post 'identity/authenticate', :to => 'sessions#authenticate', :as => :authenticate_user
    post ':provider/register', :to => 'users#create', :as => :register_user
    match ':provider/callback', :to => 'sessions#create', :as => :create_session, :via => [:get, :post]
    get 'failure', :to => 'sessions#failure'
  end

  get 'register', :to => 'users#new', :as => :registration

end
