# Load the Rails application.
if(ENV['RAILS_ASSETS_PRECOMPILE'])
  require 'rails/railtie/configuration'
  module Rails
    class Railtie
      class Configuration
        def to_prepare_blocks(*args, &block)
          []
        end
      end
    end
  end
end

require File.expand_path('../application', __FILE__)
FissionApp::Application.initialize!
