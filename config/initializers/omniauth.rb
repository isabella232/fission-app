Rails.application.config.middleware.use OmniAuth::Builder do
  if(Rails.env.production? || ENV['OMNIAUTH_ENABLE'])
    Rails.application.config.omniauth_provider = :identity
  else
    Rails.application.config.omniauth_provider = :developer
  end

  provider :identity, :fields => [:unique_id], :uid_field => :unique_id, :on_failed_registration => UsersController.action(:new)
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], {:provider_ignores_state => true}
end

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}
OmniAuth.config.logger = Rails.logger
