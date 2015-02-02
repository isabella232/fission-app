source 'https://rubygems.org'

# @todo lets look at relaxing these for easier upgrades
gem 'rails', '4.0.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 1.2'

gem 'sprockets', '2.10.1'

# @todo are we still using this?
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

# @todo where is this being used?
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
  gem 'fission-app-packager', path: '../fission-app-packager'
  gem 'fission-app-repositories', path: '../fission-app-repositories'
  gem 'fission-app-nellie', path: '../fission-app-nellie'
  gem 'fission-assets', path: '../fission-assets'
else
  source 'https://fission:8sYl7Bo0ql2OA9OPThUngg@gems.pkgd.io' do
    gem 'fission'
    gem 'fission-app-multiuser'
    gem 'fission-app-jobs'
    gem 'fission-data'
    gem 'fission-app-stripe'
    gem 'fission-app-woodchuck'
    gem 'fission-app-static'
    gem 'fission-app-sparkles'
    gem 'fission-app-docs'
    gem 'fission-app-packager'
    gem 'fission-app-repositories'
    gem 'fission-assets'
  end
end

source 'https://fission:8sYl7Bo0ql2OA9OPThUngg@gems.pkgd.io' do
  gem 'sparkle_ui'
  gem 'sparkle_builder'
end

gem 'kramdown-rails'
gem 'window_rails'

#gem 'sparkle_ui', :git => 'git@github.com:heavywater/sparkle_ui.git', :branch => 'develop'
#gem 'sparkle_builder', :git => 'git@github.com:heavywater/sparkle_builder.git', :branch => 'develop'

gemspec
