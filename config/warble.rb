Warbler::Config.new do |config|
  config.features = %w(executable)
  config.jar_name = 'fission'
  config.override_gem_home = true
  config.webserver = 'jetty'
end
