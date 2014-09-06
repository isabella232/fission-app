FissionApp::Application.routes.draw do
  get 'dashboard', :to => 'dashboard#index', :as => :dashboard
  get 'error', :to => 'application#error', :as => :error
  root 'dashboard#index'
end
