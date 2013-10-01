class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception

  helper_method :current_user
  helper_method :valid_user?

  before_action :validate_user!

  protected

  # returns if user is logged in
  def valid_user?
    session[:user_id]
  end

  # forces login if user is not valid
  def validate_user!
    attempt_token_login
    redirect_to login_url unless valid_user?
  end

  # attempt token based login (REST requests)
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

  # return instance of current user
  def current_user
    unless(@current_user)
      @current_user = User.find_by_id(session[:user_id])
    end
    @current_user
  end

  # args:: permission(s)
  # redirect if current user is not allowed
  def permit(*args)
    res = args.detect do |arg|
      current_user.permitted?(arg)
    end
    unless(res)
      redirect_to root_url, error: 'Access denied'
    else
      res
    end
  end
end
