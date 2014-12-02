FissionApp::Application.routes.draw do
  get 'dashboard', :to => 'dashboard#summary', :as => :dashboard
  get 'error', :to => 'application#error', :as => :error
end
