FissionApp::Application.routes.draw do

  resources :accounts do
    resource :order, :controller => :stripe
    resources :users
    resource :owner, :controller => :users
    resources :jobs
    resources :repositories
  end

  resources :repositories, :only => [:index] do
    get 'disable', :to => :disable
    post 'enable', :to => :enable
  end

  resources :users do
    resources :accounts
    resource :base_account, :controller => :accounts
    resources :jobs
  end

  resources :jobs do
    resource :account
    resource :user
  end

  namespace :admin do
    resources :permissions
  end

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

  get '(:path)', to: 'static#display', :constraints => {:path => /(?!assets).+/}

  root 'static#display'

end
