Warbler::Config.new do |config|
  config.features = %w(executable)
  config.java_libs += FileList["lib/java/*.jar"]
  config.jar_name = "fission-#{Time.now.to_i}"
  config.override_gem_home = true
  config.webserver = 'jetty'
  config.webxml.jruby.rack.logging = 'slf4j'
  config.includes += FileList['public/assets/manifest-*.json'].existing
  config.includes += FileList['public/assets/manifest.yml'].existing
end
