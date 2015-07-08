source 'https://rubygems.org'

# @todo lets look at relaxing these for easier upgrades
gem 'rails', '~> 4.0.0'
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jbuilder', '~> 1.2'

gem 'sprockets', '2.11.0'

# @todo are we still using this?
gem 'rouge', git: 'git://github.com/chrisroberts/rouge.git', branch: 'fix/lazyload'

group :doc do
  gem 'sdoc', require: false
end

# Web server
gem 'unicorn', :platforms => :ruby

# JS Runtime
gem 'therubyrhino', :platforms => :jruby
gem 'therubyracer', :platforms => :ruby
gem 'jruby-rack', '1.1.13.3', :platforms => :jruby

gem 'oauth_simple'
gem 'will_paginate'
gem 'haml', '>= 0.3.4'
gem 'bootstrap-sass', '3.3.5.1'
gem 'font-awesome-sass'
gem 'bootstrap_form'

group :development do
  gem 'warbler', '1.4.0'
  gem 'pry-rails'
end

group :test do
  gem 'rspec-rails'
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
#  gem 'fission-app-sparkles', path: '../fission-app-sparkles'
  gem 'fission-app-repositories', path: '../fission-app-repositories'
  gem 'fission-app-services', path: '../fission-app-services'
  gem 'fission-app-routes', path: '../fission-app-routes'
  gem 'fission-assets', path: '../fission-assets'

  gem 'fission-nellie', path: '../fission-nellie'
  gem 'fission-package-builder', path: '../fission-package-builder'
  gem 'fission-app-chat', path: '../fission-app-chat'
else
  source 'https://fission:8sYl7Bo0ql2OA9OPThUngg@gems.pkgd.io' do
    gem 'fission', '0.2.8'
    gem 'fission-app-multiuser'
    gem 'fission-app-jobs'
    gem 'fission-data'
    gem 'fission-app-stripe'
    gem 'fission-app-woodchuck'
    gem 'fission-app-static'
#    gem 'fission-app-sparkles'
    gem 'fission-app-docs'
    gem 'fission-app-repositories'
    gem 'fission-app-services'
    gem 'fission-app-routes'
    gem 'fission-app-chat'
    gem 'fission-assets'
    gem 'fission-nellie'
    gem 'fission-package-builder'
  end
end

source 'https://fission:8sYl7Bo0ql2OA9OPThUngg@gems.pkgd.io' do
  gem 'sparkle_ui'
  gem 'sparkle_builder'
end

gem 'kramdown-rails'
gem 'window_rails'

# gem 'sparkle_ui', :git => 'git@github.com:heavywater/sparkle_ui.git', :branch => 'develop'
# gem 'sparkle_builder', :git => 'git@github.com:heavywater/sparkle_builder.git', :branch => 'develop'

# List all the services available to users to allow auto registration
gem 'jackal-code-fetcher'
gem 'jackal-github-kit'
gem 'jackal-nellie'
gem 'jackal-slack'
gem 'jackal-stacks'

gemspec
