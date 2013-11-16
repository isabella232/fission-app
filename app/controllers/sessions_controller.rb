class SessionsController < ApplicationController

  before_action :validate_user!, :except => [:new, :create, :failure]

  def new
    respond_to do |format|
      format.html do
        @session = Session.new
        @provider = Rails.application.config.omniauth_provider
      end
    end
  end

  def create
    respond_to do |format|
      format.html do
        user = nil
        case auth_hash.try(:[], :provider).try(:to_sym)
        when :github
          ident = Identity.find_or_create_via_omniauth(auth_hash)
          user = ident.user if ident
        else
          user = User[params[:unique_id]]
        end
        if(user)
          session[:user_id] = user.id
          redirect_to root_url
        else
          Rails.logger.error "Failed to create user!"
          raise Error.new('Failed to create new user', :status => :internal_server_error)
        end
      end
    end
  end

  def failure
    respond_to do |format|
      format.html do
        raise Error.new('Invalid credentials provided', :status => :unauthorized)
      end
    end
  end

  def destroy
    respond_to do |format|
      format.html do
        reset_session
        redirect_to root_url, notice: 'Logged out'
      end
    end
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

  class Session
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :username, :password
    def persisted? ; false ; end
  end

end
