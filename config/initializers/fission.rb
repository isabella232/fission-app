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
  config.fission.github = config.fission.config.fetch([:github], {})

  if(config.fission.config[:static_pages] && config.fission.config[:static_pages][:path])
    config.fission.static_pages = config.fission.config[:static_pages][:path]
  else
    config.fission.static_pages = File.join(
      Gem::Specification.find_by_name('fission-app-static').full_gem_path, 'data'
    )
  end

end
