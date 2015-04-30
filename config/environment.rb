# Load the Rails application.
if(ENV['RAILS_ASSETS_PRECOMPILE'])
  require 'rails/railtie/configuration'
  class Rails::Railtie::Configuration
    def to_prepare_blocks(*args, &block)
      []
    end
  end
end

# <sigh/>
require 'action_dispatch'
class ActionDispatch::Routing::RouteSet::NamedRouteCollection::UrlHelper::OptimizedUrlHelper

  def missing_keys(args)
    args.select{ |part, arg| arg.nil? || arg.blank? }.keys
  end
end

require File.expand_path('../application', __FILE__)
FissionApp::Application.initialize!
