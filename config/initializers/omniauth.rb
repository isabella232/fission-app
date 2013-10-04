Rails.application.config.middleware.use OmniAuth::Builder do
  if(Rails.env.production? || ENV['OMNIAUTH_ENABLE'])
    Rails.application.config.omniauth_provider = :identity
  else
    Rails.application.config.omniauth_provider = :developer
    provider :developer, :fields => [:unique_id], :uid_field => :unique_id, :model => Identity
  end

  provider :identity, :fields => [:unique_id], :on_failed_registration => UsersController.action(:new)
  provider :github, 'a2a611e5f063088f73cd', 'a7f29b226a16415b8ce81f9f9a6535a735208858', {:provider_ignores_state => true}
end

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}
OmniAuth.config.logger = Rails.logger
