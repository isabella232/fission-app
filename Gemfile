source 'https://rubygems.org'

gem 'rails', '4.0.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'jbuilder', '~> 1.2'

group :doc do
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

gem 'unicorn'
gem 'omniauth', '~> 1.1'
gem 'omniauth-github'
gem 'oauth_simple'
gem 'kaminari'
gem 'haml', '>= 0.3.4', group: [ :development, :test ]
gem 'simple_form'
gem 'bootstrap-sass', git: 'git://github.com/thomas-mcdonald/bootstrap-sass'

group :development do
  gem 'pry-rails'
end

group :test do
  gem 'rspec-rails', group: :test
  gem 'capybara'
end

gem 'octokit'
gem 'risky', git: 'git://github.com/chrisroberts/risky.git', branch: 'updates'

if(ENV['FISSION_LOCALS'] == 'true')
  gem 'fission-app-jobs', path: '../fission-app-jobs', require: 'fission-app-jobs/version'
  gem 'fission-data', path: '../fission-data'
  gem 'fission_stripe', path: '../fission_stripe'
  gem 'fission-app-static', path: '../fission-app-static'
else
  gem 'fission-app-jobs', git: 'git@github.com:heavywater/fission-app-jobs.git', branch: 'develop', require: 'fission-app-jobs/version'
  gem 'fission-data', git: 'git@github.com:heavywater/fission-data.git', branch: 'develop'
  gem 'fission_stripe', git: 'git@github.com:heavywater/fission_stripe.git', branch: 'develop'
  gem 'fission-app-static', git: 'git@github.com:heavywater/fission-app-static', branch: 'develop'
end

#gem 'trinidad'

gemspec
