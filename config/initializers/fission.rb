require 'carnivore'
require 'bogo-config'

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

  FissionApp::Config = Bogo::Config.new(fission_file)

  base_hash = FissionApp::Config.data
  unless(valid_config_paths.last == fission_file)
    base_file = JSON.load(File.read(valid_config_paths.last)).to_smash
    base_hash = base_file.deep_merge(base_hash)
  end

  config.fission.config = base_hash.with_indifferent_access
  config.settings = Smash.new(base_hash)
  config.fission_assets = Fission::Assets::Store.new(
    FissionApp::Config.get(:fission, :assets)
  )

  unless(ENV['RAILS_ASSETS_PRECOMPILE'])
    config.settings.set(:engines,
      Rails.application.railties.engines.map{ |eng|
        eng.engine_name.sub('_engine', '')
      }
    )
  end

  # All of this junk needs to be deprecated and scrubbed from engines.
  # They should be using #fetch on the settings directly

  config.fission.pricing = config.fission.config[:pricing]
  config.fission.json_support = config.fission.config[:json_style]
  config.fission.site_brand = config.fission.config[:site_brand]
  config.fission.rest_endpoint = config.fission.config[:fission][:rest_endpoint]
  config.fission.rest_endpoint_ssl = config.fission.config[:fission][:rest_endpoint_ssl]
  config.fission.github = config.fission.config.fetch(:github, {}).with_indifferent_access
  config.fission.stripe = config.fission.config.fetch(:stripe, {}).with_indifferent_access
  config.fission.whitelist = config.fission.config.fetch(:whitelist, {}).with_indifferent_access
  config.fission.analytics = config.fission.config.fetch(:analytics, {}).with_indifferent_access
  config.fission.intercom_io = config.fission.config.fetch(:intercom_io, {}).with_indifferent_access

  config.fission.whitelist[:users] ||= []
  config.fission.whitelist[:redirect_to] ||= '/beta'

  if(config.fission.config[:static_pages] && config.fission.config[:static_pages][:path])
    config.fission.static_pages = config.fission.config[:static_pages][:path]
  else
    static_gem_spec = Gem::Specification.find_by_name('fission-app-static')
    if(static_gem_spec)
      config.fission.static_pages = File.join(
        static_gem_spec.full_gem_path, 'data'
      )
    end
  end

  if(config.fission.static_pages)
     config.fission.static_pages_content = Smash.new
    Dir.glob(File.join(config.fission.static_pages, '**', '**', '*')).each do |path|
      extension = File.extname(path)
      key = path.sub(config.fission.static_pages, '').sub(extension, '').sub(/^\//, '')
      if(extension == '.json')
        config.fission.static_pages_content[key] = JSON.load(File.read(path)).to_smash
      elsif(extension == '.yml')
        config.fission.static_pages_content[key] = YAML.load(File.read(path)).to_smash
      else
        Rails.logger.warn "Unsupported file type for static page: #{path}"
      end
    end
  end

  config.fission.fission_router = config.fission.config.fetch(:router_source, {}).with_indifferent_access
  config.fission.repository_api = config.fission.config.fetch(:repository_api, 'repository.pkgd.io')

  config.fission.mail = config.fission.config.fetch(:mail,
    :to => 'fission@hw-ops.com',
    :name => 'Fission UI',
    :subject => 'Generated Email'
  ).with_indifferent_access

end

if(defined?(Fission::Data::Models))
  Cell::Rails.send(:include, Fission::Data::Models)
end
