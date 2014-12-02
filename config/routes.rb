FissionApp::Application.routes.draw do
  get 'switch/:account_id', :to => 'application#switch', :as => :switch
  get 'dashboard', :to => 'dashboard#summary', :as => :dashboard
  get 'error', :to => 'application#error', :as => :error
end
