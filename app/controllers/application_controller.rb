class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception

  helper_method :current_user
  helper_method :valid_user?

  before_action :validate_user!

  protected

  def valid_user?
    session[:user_id]
  end

  def validate_user!
    attempt_token_login
    redirect_to login_url unless valid_user?
  end

  def attempt_token_login
    if(%w(xml json).include?(request.format.to_s.downcase))
      if(request.headers[:fission_key] && request.headers[:fission_secret])
        user = User.authenticate_by_api_token(
          request.headers[:fission_key], request.headers[:fission_secret]
        )
        session[:user_id] = user.id if user
      end
    end
  end
end
