FissionApp::Application.routes.draw do
  get 'error', :to => 'application#error', :as => :error
end
