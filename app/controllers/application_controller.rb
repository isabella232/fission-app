require 'fission-app'

class ApplicationController < ActionController::Base

  # Session keys that must persist on account switching
  PROTECTED_SESSION_KEYS = ['random', 'user_id', 'validator']

  # Load in any modules we care about
  include FissionApp::Errors
  if(defined?(Fission::Data::Models))
    include Fission::Data::Models
  end
  include FissionApp::Commons

  # Define simple callbacks for easy event based pipeline injections
  include ActiveSupport::Callbacks

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception

  rescue_from FissionApp::Errors::Error::MissingAccessToken, :with => :invalidate_session
  rescue_from StandardError, :with => :exception_handler

  # User access helpers
  helper_method :current_user
  helper_method :valid_user?
  helper_method :isolated_product?
  helper_method :default_url
  helper_method :engine?

  # Set analytics variables
  before_action :analytics

  # Load the product
  before_action :load_product!

  # Always validate
  before_action :validate_user!, :if => lambda{ user_mode? }, :except => [:error]

  # Load the current account
  before_action :load_current_account!, :if => lambda{ user_mode? && valid_user? }

  # Check user is permitted on path
  before_action :validate_access!, :if => lambda{ user_mode? && valid_user? }, :except => [:error, :switch]

  # Run any registered pre action callbacks
  before_action :pre_registered_callbacks

  # Set helpdesk variables
  before_action :helpdesk

  # Define navigation
  before_action :set_navigation, :if => lambda{ user_mode? && valid_user? }

  # Add content_for entries
  before_action :register_default_icons

  # Run any registered post action callbacks
  after_action :post_registered_callbacks

  # Just say no to infinity
  after_action :reset_redirect_counter

  # Store custom data session changes
  after_action :save_user_session, :if => lambda{ user_mode? && valid_user? }

  # Proxy for account switching
  def switch
    flash[:notice] = "Account updated! (#{current_user.run_state.current_account.name})"
    session.keys.each do |key|
      unless(PROTECTED_SESSION_KEYS.include?(key.to_s))
        session.delete(key)
      end
    end
    respond_to do |format|
      format.js do
        @accounts = current_user.accounts
      end
      format.html do
        redirect_to dashboard_url
      end
    end
  end

  protected

  # Used for event notification on actions. This is the generic
  # notifier with notifications being enabled/disabled via
  # configuration
  #
  # @return [TrueClass]
  def notify!
    true
  end

  # @return [TrueClass, FalseClass] isolated to single product
  def isolated_product?
    !!@isolated_product
  end

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
        if(@current_user)
          unless(session[:validator] == user_checksum(@current_user))
            flash[:error] = 'User validation failed! You have been logged out!'
            @current_user = nil
          end
        end
        unless(@current_user)
          session.clear
        else
          @current_user.run_state.random_sec = session[:random]
        end
      end
    end
    @current_user
  end

  # Init `@product`
  def load_product!
    @product = Product.find_by_vanity_dns(request.host)
    if(@product)
      @app_name = @product.name
      @isolated_product = true
    else
      if(params[:namespace])
        @product = Product.find_by_internal_name(params[:namespace])
      elsif(@product.nil? && (path_parts = request.path.split('/')).size > 1)
        @product = Product.find_by_internal_name(path_parts[1])
      end
    end
    if(@product && current_user)
      current_user.run_state.current_product = @product
    end
    @site_style = :application
    @product
  end

  # Check that user has permission to defined paths
  #
  # @raises [Error::PermissionDeniedError]
  def validate_access!
    match = current_user.run_state.active_permissions.map(&:pattern).detect do |regex|
      regex.match(request.path)
    end
    unless(match)
      Rails.logger.error "Failed to match request path (#{request.path}) to valid permission! (account: #{current_user.run_state.current_account.inspect})"
      raise Error::PermissionDeniedError.new 'Access denied'
    end
  end

  # Validate user is logged in and set
  def validate_user!
    unless(valid_user?)
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
    end
  end

  # Load current account and fail if unable to detect valid account
  def load_current_account!
    acct_id = params.fetch(:account_id,
      current_user.session[:current_account_id]
    )
    if(acct_id)
      @account = current_user.accounts.detect do |account|
        account.id.to_s == acct_id.to_s
      end
    else
      @account = current_user.accounts.first
    end
    unless(@account)
      flash[:error] = 'Failed to set account for user!'
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
      current_user.session[:current_account_id] = @account.id
      current_user.run_state.current_account = @account
      if(@account.customer_payment)
        current_user.run_state.plans = @account.customer_payment.plans(isolated_product? ? @product : nil)
      else
        current_user.run_state.plans = []
      end
      current_user.run_state.products = @account.products(isolated_product? ? @product : nil)
      current_user.run_state.product_features = @account.product_features(isolated_product? ? @product: nil)
      current_user.run_state.active_permissions = @account.active_permissions(isolated_product? ? @product : nil)
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
      msg = error.is_a?(Error) ? error.message : "Unexpected error: #{error.message}"
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

  # Invalidate the session and direct user to login again
  #
  # @param error [Exception]
  def invalidate_session(error)
    Rails.logger.error "Failed to locate GitHub token for user: #{current_user.username}!"
    session.clear!
    flash[:error] = 'Session has timed out! Please login again.'
    respond_to do |format|
      format.js do
        javascript_redirect_to login_path
      end
      format.html do
        redirec_to login_path
      end
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

  # Load google analytics if running in production
  #
  # @return [TrueClass, FalseClass]
  def analytics
    if(Rails.env == 'production')
      dns = request.host.to_s
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
          :accounts => current_user.accounts.size
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

  # Register default icon buttons for CRUD
  def register_default_icons
    content_for(:delete_icon, '<span class="glyphicon glyphicon-trash btn btn-xs btn-danger"/>'.html_safe)
    content_for(:edit_icon, '<span class="glyphicon glyphicon-pencil btn btn-xs btn-warning"/>'.html_safe)
    content_for(:create_icon, '<span class="glyphicon glyphicon-plus btn btn-xs btn-success"/>'.html_safe)
    content_for(:save_icon, '<span class="glyphicon glyphicon-floppy-disk btn btn-xs btn-primary"/>'.html_safe)
    content_for(:ok_icon, '<span class="glyphicon glyphicon-ok btn btn-xs btn-success"/>'.html_safe)
    content_for(:danger_icon, '<span class="glyphicon glyphicon-warning-sign btn btn-xs btn-danger"/>'.html_safe)
  end

  # @return [TrueClass, FalseClass] users are enabled
  def user_mode?
    Rails.application.railties.engines.detect do |engine|
      engine.engine_name == 'fission_app_multiuser_engine'
    end
  end

  # @return [Hash] user enabled navigation
  # @todo Need to add an ordering option for processing through
  # products and engines to force nav ordering
  def set_navigation
    products = current_user.run_state.products
    if(isolated_product?)
      products = products.find_all do |product|
        product == @product
      end
    end
    @navigation = Smash.new
    @account_navigation = Smash.new
    products.each do |product|
      Rails.application.railties.engines.sort_by(&:engine_name).each do |eng|
        if(eng.respond_to?(:fission_product))
          next unless eng.fission_product.include?(product)
        end
        if(eng.respond_to?(:fission_navigation))
          @navigation.deep_merge!(eng.fission_navigation(product, current_user).to_smash)
        end
        if(eng.respond_to?(:fission_account_navigation))
          @account_navigation.deep_merge!(eng.fission_account_navigation(product, current_user).to_smash)
        end
      end
    end
    @navigation = @navigation.to_smash(:sorted)
    @account_navigation = @account_navigation.to_smash(:sorted)
    [@navigation, @account_navigation]
  end

  # Run any registered callbacks before running action
  def pre_registered_callbacks
    callback_args = Smash.new(
      :params => params,
      :request => request,
      :current_user => current_user
    )
    Rails.application.config.settings.fetch(:callbacks, :before, params[:controller], params[:action], {}).each do |k,v|
      Rails.logger.info "Running matching registered pre action callback: #{k}"
      self.instance_exec(callback_args, &v)
    end
  end

  # Run any registered callbacks after running action
  def post_registered_callbacks
    callback_args = Smash.new(
      :params => params,
      :request => request,
      :current_user => current_user
    )
    Rails.application.config.settings.fetch(:callbacks, :after, params[:controller], params[:action], {}).each do |k,v|
      Rails.logger.info "Running matching registered post action callback: #{k}"
      self.instance_exec(callback_args, &v)
    end
  end

  # Generate identifier digest
  #
  # @param user [Fission::Data::Models::User]
  # @return [String]
  def user_checksum(user)
    Digest::SHA256.hexdigest(
      [user.id, user.username,
        Rails.application.config.secret_key_base]
        .map(&:to_s).join('-')
    )
  end

  # Force a 404 error
  def not_found!(msg='Page not found')
    raise ActionController::RoutingError.new(msg)
  end

end
