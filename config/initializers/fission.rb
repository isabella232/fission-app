class FissionApp::Application

  config.fission = ActiveSupport::Configurable::Configuration.new

  config.fission.json_support = :jsend
  config.fission.site_brand = 'Fission'
  config.fission.rest_endpoint = 'http://alpha.hw-ops.com'
  config.fission.rest_endpoint_ssl = 'https://alpha.hw-ops.com'

end
