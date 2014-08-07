FissionApp::Application.routes.draw do

  namespace :admin do
    resources :accounts do
      resources :users
      resources :permissions
      resources :tokens
    end
    resources :users do
      resources :tokens
    end
    resources :sources do
      resources :accounts
    end
    resources :permissions
  end

  resources :accounts
  resources :users

  scope :session do
    get 'login', :to => 'sessions#new', :as => :new_session
    get 'logout', :to => 'sessions#destroy', :as => :destroy_session
  end
  get 'login', :to => 'sessions#new'

  scope :auth do
    post 'identity/authenticate', :to => 'sessions#authenticate', :as => :authenticate_user
    post ':provider/register', :to => 'users#create', :as => :register_user
    match ':provider/callback', :to => 'sessions#create', :as => :create_session, :via => [:get, :post]
    get 'failure', :to => 'sessions#failure'
  end

  get 'register', :to => 'users#new', :as => :registration
  get 'dashboard', :to => 'dashboard#index', :as => :dashboard

  scope :utilities do
    post 'form_mailer', :to => 'utilities#form_mailer', :as => :form_mailer_utility
  end

  root 'static#display'

end
