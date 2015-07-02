FissionApp::Application.routes.draw do
  get 'switch(/:account_id)', :to => 'application#switch', :as => :account_switch
  get 'dashboard', :to => 'dashboard#summary', :as => :dashboard
  get 'error', :to => 'application#error', :as => :error
  get 'status', :to => 'application#status', :as => :status
end
