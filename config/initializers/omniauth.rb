Rails.application.config.middleware.use OmniAuth::Builder do
  if(Rails.env.production? || ENV['ENABLE_OMNIAUTH'])
    Rails.application.config.omniauth_provider = :identity
  else
    Rails.application.config.omniauth_provider = :developer
  end
  github_key = ENV.fetch('GITHUB_KEY', Rails.application.config.fission.github[:key])
  github_secret = ENV.fetch('GITHUB_SECRET', Rails.application.config.fission.github[:secret])
  provider(:github, github_key, github_secret, scope: 'user:email,repo')
end

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}
OmniAuth.config.logger = Rails.logger
