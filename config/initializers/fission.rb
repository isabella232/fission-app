class FissionApp::Application

  config.fission = ActiveSupport::Configurable::Configuration.new

  valid_config_paths = [
    ENV['FISSION_APP_JSON'],
    '/etc/fission/app.json',
    File.join(File.dirname(__FILE__), '..', 'fission.json')
  ].compact

  fission_file = valid_config_paths.detect do |path|
    File.exists?(path)
  end

  raise "No fission configuration file detected!" unless fission_file

  config.fission.config = JSON.load(File.read(fission_file)).with_indifferent_access

  unless(valid_config_paths.last == fission_file)
    base_file = JSON.load(File.read(valid_config_paths.last)).with_indifferent_access
    config.fission.config = base_file.deep_merge(config.fission.config)
  end

  config.fission.pricing = config.fission.config[:pricing]
  config.fission.json_support = config.fission.config[:json_style]
  config.fission.site_brand = config.fission.config[:site_brand]
  config.fission.rest_endpoint = config.fission.config[:fission][:rest_endpoint]
  config.fission.rest_endpoint_ssl = config.fission.config[:fission][:rest_endpoint_ssl]
  config.fission.github = config.fission.config.fetch(:github, {}).with_indifferent_access
  config.fission.stripe = config.fission.config.fetch(:stripe, {}).with_indifferent_access
  config.fission.whitelist = config.fission.config.fetch(:whitelist, {}).with_indifferent_access
  config.fission.analytics = config.fission.config.fetch(:analytics, {}).with_indifferent_access

  config.fission.whitelist[:users] ||= []
  config.fission.whitelist[:redirect_to] ||= '/s/beta'

  if(config.fission.config[:static_pages] && config.fission.config[:static_pages][:path])
    config.fission.static_pages = config.fission.config[:static_pages][:path]
  else
    config.fission.static_pages = File.join(
      Gem::Specification.find_by_name('fission-app-static').full_gem_path, 'data'
    )
  end

  config.fission.fission_router = config.fission.config.fetch(:router_source, {}).with_indifferent_access

end

require 'fission-app/backgroundable'

unless(Rails.application.config.fission.fission_router.empty?)

  require 'carnivore'

  Carnivore.configure do
    Carnivore::Source.build(
      :type => Rails.application.config.fission.fission_router[:type],
      :args => Rails.application.config.fission.fission_router[:args].with_indifferent_access.merge(:name => :router)
    )
  end
  Rails.application.config.backgroundable = Fission::App::Backgroundable.new(:endpoint => :router)
else
  Rails.application.config.backgroundable = Fission::App::Backgroundable.new
end
