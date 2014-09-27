source 'https://rubygems.org'

gem 'rails', '4.0.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 1.2'

gem 'sprockets', '2.10.1'

gem 'rouge', git: 'git://github.com/chrisroberts/rouge.git', branch: 'fix/lazyload'

group :doc do
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# Web server
gem 'unicorn', :platforms => :ruby

# JS Runtime
gem 'therubyrhino', :platforms => :jruby
gem 'therubyracer', :platforms => :ruby
gem 'jruby-rack', '1.1.13.3', :platforms => :jruby

gem 'oauth_simple'
gem 'will_paginate'
gem 'haml', '>= 0.3.4'
gem 'bootstrap-sass'

group :development do
  gem 'warbler', '1.4.0'
  gem 'pry-rails'
end

group :test do
  gem 'rspec-rails', group: :test
  gem 'capybara'
end

gem 'octokit'

gem 'jdbc-postgres', :platforms => :jruby
gem 'pg', :platforms => :ruby

gem 'momentjs-rails', '~> 2.5.0'
gem 'bootstrap3-datetimepicker-rails', '~> 3.0.0'

if(ENV['FISSION_LOCALS'] == 'true')
  gem 'fission', path: '../fission'
  gem 'fission-app-multiuser', path: '../fission-app-multiuser'
  gem 'fission-app-jobs', path: '../fission-app-jobs'
  gem 'fission-data', path: '../fission-data', :require => false
  gem 'fission-app-stripe', path: '../fission-app-stripe'
  gem 'fission-app-static', path: '../fission-app-static'
  gem 'fission-app-woodchuck', path: '../fission-app-woodchuck'
  gem 'fission-app-docs', path: '../fission-app-docs'
  gem 'fission-app-sparkles', path: '../fission-app-sparkles'
else
  gem 'fission', git: 'git@github.com:heavywater/fission.git', branch: 'develop'
  gem 'fission-app-multiuser', git: 'git@github.com:heavywater/fission-app-multiuser.git', branch: 'develop'
  gem 'fission-app-jobs', git: 'git@github.com:heavywater/fission-app-jobs.git', branch: 'develop'
  gem 'fission-data', git: 'git@github.com:heavywater/fission-data.git', branch: 'develop'
  gem 'fission-app-stripe', git: 'git@github.com:heavywater/fission-app-stripe.git', branch: 'develop'
  gem 'fission-app-woodchuck', git: 'git@github.com:heavywater/fission-app-woodchuck', branch: 'develop'
  gem 'fission-app-static', git: 'git@github.com:heavywater/fission-app-static', branch: 'develop'
  gem 'fission-app-sparkles', git: 'git@github.com:heavywater/fission-app-sparkles.git', branch: 'develop'
  gem 'fission-app-docs', git: 'git@github.com:heavywater/fission-app-docs.git', branch: 'develop'
end

gem 'knife-cloudformation', :git => 'git://github.com/heavywater/knife-cloudformation', :branch => 'feature/fog-model'
gem 'sparkle_formation', :git => 'git://github.com/heavywater/sparkle_formation', :branch => 'develop'

gem 'fog', :git => 'git://github.com/chrisroberts/fog', :branch => 'feature/orchestration'
gem 'fog-core', :git => 'git://github.com/chrisroberts/fog-core', :branch => 'feature/orchestration'
gem 'kramdown-rails'
gem 'carnivore'

gem 'window_rails', :git => 'git://github.com/chrisroberts/window_rails', :branch => 'develop'

gem 'sparkle_ui', :git => 'git@github.com:heavywater/sparkle_ui.git', :branch => 'develop'
gem 'sparkle_builder', :git => 'git@github.com:heavywater/sparkle_builder.git', :branch => 'develop'

gemspec
