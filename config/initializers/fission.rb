class FissionApp::Application

  config.fission = ActiveSupport::Configurable::Configuration.new

  config.fission.json_support = :jsend
  config.fission.site_brand = 'Fission'

end
