require 'fission-app'

class ApplicationController < ActionController::Base

  # Load in any modules we care about
  include FissionApp::Errors
  if(defined?(Fission::Data::Models))
    include Fission::Data::Models
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception

  rescue_from StandardError, :with => :exception_handler

  # User access helpers
  helper_method :current_user
  helper_method :valid_user?

  # Set analytics variables
  before_action :analytics

  # Always validate
  before_action :validate_user!, :if => lambda{ user_mode? }, :except => [:error]

  # Load the product and applicable accounts
  before_action :load_product_accounts!, :if => lambda{ user_mode? && valid_user? }

  # Cache permission
  before_action :cache_user_permissions, :if => lambda{ user_mode? && valid_user? }

  # Check user is permitted on path
  before_action :validate_user_permission!, :if => lambda{ user_mode? && valid_user? }

  # Check account is permitted on path
  before_action :validate_account_permission!, :if => lambda{ user_mode? && valid_user? }

  # Set helpdesk variables
  before_action :helpdesk

  # Define navigation
  before_action :set_navigation, :if => lambda{ user_mode? && valid_user? }

  # Just say no to infinity
  after_action :reset_redirect_counter

  # Store custom data session changes
  after_action :save_user_session, :if => lambda{ user_mode? && valid_user? }

  protected

  # @return [String] default root url
  # @note will return dashboard url for logged in users
  def default_url
    valid_user? ? dashboard_path : '/index'
  end

  # @return [TrueClass, FalseClass] user is logged in
  def valid_user?
    !!current_user
  end

  # @return [Fission::Data::User] current user instance
  def current_user
    if((Rails.env != 'production' && ENV['FISSION_AUTHENTICATION_DISABLE'] == 'true'))
      session[:user_id] = User.first.id
    end
    unless(@current_user)
      if(session[:user_id])
        @current_user = User.find_by_id(session[:user_id])
        unless(@current_user)
          session.clear
        end
      end
    end
    @current_user
  end

  # Init `@product` and `@accounts`
  def load_product_accounts!
    if(params[:namespace])
      account_ids = current_user.accounts.map do |act|
        if(params[:account_id])
          if(act.id.to_s == params[:account_id])
            act.id
          end
        else
          act.id
        end
      end.compact
      @product = Product.find_by_internal_name(params[:namespace])
      @accounts = Account.eager_graph(:product_features => :product).
        where(:account_id => account_ids).
        where(:product_id => @product.id).all
    else
      @product = nil
      @accounts = []
    end
  end

  # Cache valid user permissions into user run_state
  def cache_user_permissions
    current_paths = current_user.run_state.allowed_paths
    if(current_paths.nil? || current_paths.empty?)
      unless(current_user.session[:allowed_paths])
        patterns = current_user.permissions.map(&:pattern)
        current_user.session[:allowed_paths] = patterns.map(&:to_s)
      else
        patterns = current_user.session[:allowed_paths].map do |pattern|
          Regexp.new(pattern)
        end
      end
      current_user.run_state.allowed_paths = patterns
    end
  end

  # Check that user has permission to defined paths
  #
  # @raises [Error::PermissionDeniedError]
  def validate_user_permission!
    match = current_user.run_state.allowed_paths.detect do |regex|
      regex.match(request.path)
    end
    unless(match)
      Rails.logger.error "Failed to match request path (#{request.path}) to valid permission (user)!"
      raise Error::PermissionDeniedError.new 'Access denied'
    end
  end

  # Check that account has permission to defined paths
  #
  # @raises [Error::PermissionDeniedError]
  def validate_account_permission!
    if(params[:account_id])
      account = @accounts.first
      match = account.active_permissions.map(&:pattern).detect do |regex|
        regex.match(request.path)
      end
      unless(match)
        Rails.logger.error "Failed to match request path (#{request.path}) to valid permission (account)!"
        raise Error::PermissionDeniedError.new 'Access denied'
      end
    end
  end

  # Validate user is logged in and set
  def validate_user!
    unless(valid_user?)
      flash.each do |k,v|
        flash[k] = v
      end
      respond_to do |format|
        format.html do
          redirect_to default_url
        end
        format.json do
          unless(api_validate)
            render :json => json_response('Access denied', :fail)
          end
        end
      end
    else
      whitelist_validate!
    end
  end

  # Validate user is found within whitelist. Redirect user
  # if not found
  #
  # @param redirect [TrueClass, FalseClass] redirect user if not found
  # @return [TrueClass, FalseClass]
  def whitelist_validate!(redirect=true)
    if(Rails.application.config.fission.whitelist)
      if(Whitelist.where(:username => current_user.username).count == 0)
        Rails.logger.error "User is not listed within whitelist (#{current_user.username})"
        redirect_to Rails.application.config.fission.whitelist[:redirect_to]
        false
      else
        true
      end
    else
      true
    end
  end

  # Handle uncaught exceptions. Set error and redirect back
  # to root URL. If root url is causing exception leading to
  # recursive redirect, forcibly render error page out.
  #
  # @param error [Exception]
  # @note exceptions will propogate out in development mode
  def exception_handler(error)
    unless(Rails.env == 'development')
      Rails.logger.error "#{error.class}: #{error} - (user: #{current_user.try(:username)})"
      Rails.logger.debug "#{error.class}: #{error}\n#{error.backtrace.join("\n")}"
      msg = error.is_a?(Error) ? error.message : 'Unknown error encountered'
      session[:redirect_count] ||= 0
      session[:redirect_count] += 1
      @error_state = true
      respond_to do |format|
        format.html do
          flash[:error] = msg
          if(session[:redirect_count] > 5)
            Rails.logger.error 'Caught in redirect loop. Bailing out!'
            render
          else
            redirect_to default_url
          end
        end
        format.json do
          render(
            :json => json_response(nil, :error, :message => msg),
            :status => error.respond_to?(:status_code) ? error.status_code : :internal_server_error
          )
        end
      end
    else
      raise error
    end
  end

  # Reset the redirect counter back to zero on successful completion
  def reset_redirect_counter
    session[:redirect_count] = 0 unless @error_state
  end

  # Save the user session on the way out
  def save_user_session
    current_user.active_session.save
  end

  # Build github API client
  #
  # @param ident [Symbol] :bot or :user
  # @return [Octokit::Client]
  def github(ident)
    Octokit.auto_paginate = true
    case ident
    when :bot
      token = Rails.application.config.settings.get(:github, :token)
    when :user
      token = current_user.token_for(:github)
    else
      raise "Unknown GitHub identity requested for use: #{ident.inspect}"
    end
    Octokit::Client.new(:access_token => token)
  end

  # Load google analytics if running in production
  #
  # @return [TrueClass, FalseClass]
  def analytics
    if(Rails.env == 'production')
      dns = request.env.fetch('SERVER_NAME', '')
      property = Rails.application.config.fission.analytics[:properties].detect do |key, value|
        dns.include?(key.to_s)
      end
      if(property)
        @analytics = {
          :ref => [Rails.application.config.fission.analytics[:account], property.last].join('-'),
          :name => property.first
        }
        true
      else
        Rails.logger.warn "Failed to locate analytics property using connected DNS (#{dns})"
        false
      end
    else
      false
    end
  end

  # Load helpdesk if running in production
  #
  # @return [TrueClass, FalseClass]
  # @note only loads if in production, enabled in config, and user
  #   logged in
  def helpdesk
    if(Rails.env == 'production' && current_user && Rails.application.config.fission.intercom_io[:enabled])
      unless(session[:intercom_args])
        @intercom_args = {
          :name => current_user.username,
          :email => current_user.email,
          :created_at => current_user.created_at.to_time.to_i,
          :app_id => Rails.application.config.fission.intercom_io[:app_id],
          :accounts => Account.restrict(current_user).size,
          :repos => Repository.restrict(current_user).size
        }
        if(Rails.application.config.fission.intercom_io[:secure_mode])
          @intercom_args.merge!(
            :user_hash => OpenSSL::HMAC.hexdigest(
              'sha256', Rails.application.config.fission.intercom_io[:secure_mode], current_user.email
            )
          )
        end
        session[:intercom_args] = @intercom_args
      end
      @intercom_args = session[:intercom_args].try(:dup)
      true
    else
      false
    end
  end

  # Redirect browser via javascript response
  #
  # @param url [String] destination
  # @return [String]
  def javascript_redirect_to(url)
    render :js => "window.document.location = '#{url}';"
  end

  # @return [Integer] page number for pagination
  def page(param_name=nil)
    (params[param_name || :page] || 1).to_i
  end

  # @return [Integer] default items per page for pagination
  def per_page
    Rails.application.config.fission[:pagination].try(:[], :per_page) || 25
  end

  # Sets pagination content block for given collection
  #
  # @param collection [Enumerable]
  # @param args [Hash]
  # @option args [Symbol] :id content_for identifier (defaults :pagination)
  # @option args [Symbol] :param_name link parameter name (defaults :page)
  def enable_pagination_on(collection, args={})
    unless(collection.nil? || collection.empty?)
      content_for(args.fetch(:id, :pagination),
        view_context.will_paginate(collection,
          :renderer => BootstrapPagination::Rails,
          :class => 'pagination-sm',
          :param_name => args.fetch(:param_name, :page)
        )
      )
    end
  end

  # @return [TrueClass, FalseClass] users are enabled
  def user_mode?
    Rails.application.railties.engines.detect do |engine|
      engine.engine_name == 'fission_app_multiuser_engine'
    end
  end

  # @return [Hash] user enabled navigation
  def set_navigation
    @navigation = {}.with_indifferent_access.tap do |nav|
      current_user.active_products.each do |product|
        Rails.application.railties.engines.each do |eng|
          if(eng.respond_to?(:fission_product))
            if(eng.fission_product.include?(product))
              if(eng.respond_to?(:fission_navigation))
                nav.merge!(eng.fission_navigation.with_indifferent_access)
              end
            end
          end
        end
      end
    end
  end

end
