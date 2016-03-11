require File.expand_path('../boot', __FILE__)

require "active_model/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

require 'will_paginate'
require 'will_paginate/sequel'
require 'fission-data'
require 'lograge'

module FissionApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.asset_mappings = {}
    Rails::Engine.descendants.each do |klass|
      next if ['FissionApp::Application', 'Rails::Application'].include?(klass.name)
      next unless klass.respond_to?(:root)
      if(File.exists?(klass.root.join('app/assets')))
        if(File.exists?(klass.root.join('app/controllers')))
          config.asset_mappings[klass] = {
            :controllers => Dir.glob(File.join(klass.root.join('app/controllers').to_path, '**', '*.rb')).map{ |path|
              path.sub("#{klass.root.join('app/controllers').to_path}/", '').sub('.rb', '').camelize
            },
            :css => [],
            :js => []
          }
          assets_path = klass.root.join('app/assets').to_path
          config.assets.paths << assets_path.sub('/assets', '')
          Dir.glob(klass.root.join('app/assets/stylesheets/*.scss').to_path).each do |s_path|
            config.asset_mappings[klass][:css].push(File.basename(s_path).sub('.scss', '').sub('.css', ''))
            config.assets.precompile << File.basename(s_path).sub('.scss', '')
          end
          Dir.glob(klass.root.join('app/assets/javascripts/*.js').to_path).each do |j_path|
            config.asset_mappings[klass][:js].push(File.basename(j_path).sub('.js', ''))
            config.assets.precompile << File.basename(j_path)
          end
        end
      end
    end
    config.json_format = :jsend
    config.railties_order = [:main_app, :all, FissionApp::Static::Engine]
  end
end
