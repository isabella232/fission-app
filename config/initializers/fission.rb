class FissionApp::Application

  config.fission = ActiveSupport::Configurable::Configuration.new

  config.fission.config = JSON.load(
    File.read(
      File.join(File.dirname(__FILE__), '..', 'fission.json')
    )
  ).with_indifferent_access

  config.fission.json_support = config.fission.config[:json_style]
  config.fission.site_brand = config.fission.config[:site_brand]
  config.fission.rest_endpoint = config.fission.config[:fission][:rest_endpoint]
  config.fission.rest_endpoint_ssl = config.fission.config[:fission][:rest_endpoint_ssl]

  config.fission.static_pages = config.fission.config[:static_pages][:path]

end
