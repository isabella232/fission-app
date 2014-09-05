FissionApp::Application.routes.draw do

  get 'dashboard', :to => 'dashboard#index', :as => :dashboard

  scope :utilities do
    post 'form_mailer', :to => 'utilities#form_mailer', :as => :form_mailer_utility
  end

  root 'static_pages#show'

end
