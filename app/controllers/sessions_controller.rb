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
        omniauth = request.env['omniauth.auth']
        user = nil
        case omniauth[:provider].to_sym
        when :github
          ident = Identity.find_or_create_via_omniauth(omniauth)
          user = ident.user if ident
        else
          user = User.where(:username => params[:unique_id]).first
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

  class Session
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :username, :password
    def persisted? ; false ; end
  end

end
