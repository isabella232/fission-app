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
gem 'warbler', :platforms => :jruby

group :development do
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
  gem 'fission-app-sparkles', path: '../fission-app-sparkles'
  gem 'fission-app-repositories', path: '../fission-app-repositories'
  gem 'fission-app-services', path: '../fission-app-services'
  gem 'fission-app-routes', path: '../fission-app-routes'
  gem 'fission-assets', path: '../fission-assets'

  gem 'fission-nellie', path: '../fission-nellie'
  gem 'fission-package-builder', path: '../fission-package-builder'
  gem 'fission-app-chat', path: '../fission-app-chat'
  gem 'fission-repository-generator', path: '../fission-repository-generator'
  gem 'fission-repository-publisher', path: '../fission-repository-publisher'
  gem 'fission-stacks', path: '../fission-stacks'
  gem 'sparkle_ui', :git => 'git@github.com:sparkleformation/sparkle_ui.git', :branch => 'develop'
  gem 'sparkle_builder', :git => 'https://github.com/sparkleformation/sparkle_builder.git', :branch => 'develop'
else
#  source 'https://fission:8sYl7Bo0ql2OA9OPThUngg@gems.pkgd.io' do
  gem 'fission', :git => 'https://github.com/hw-product/fission.git', :branch => 'develop'
  #'0.3.14'
    gem 'fission-app-multiuser', :git => 'https://github.com/hw-product/fission-app-multiuser.git', :branch => 'develop'
    gem 'fission-app-jobs', :git => 'https://github.com/hw-product/fission-app-jobs.git', :branch => 'develop'
    gem 'fission-data', :git => 'https://github.com/hw-product/fission-data.git', :branch => 'develop'
    gem 'fission-app-stripe', :git => 'https://github.com/hw-product/fission-app-stripe.git', :branch => 'develop'
    gem 'fission-app-woodchuck', :git => 'https://github.com/hw-product/fission-app-woodchuck.git', :branch => 'develop'
    gem 'fission-app-static', :git => 'https://github.com/hw-product/fission-app-static.git', :branch => 'develop'
    gem 'fission-app-sparkles', :git => 'https://github.com/hw-product/fission-app-sparkles.git', :branch => 'develop'
    gem 'fission-app-docs', :git => 'https://github.com/hw-product/fission-app-docs.git', :branch => 'develop'
    gem 'fission-app-repositories', :git => 'https://github.com/hw-product/fission-app-repositories.git', :branch => 'develop'
    gem 'fission-app-services', :git => 'https://github.com/hw-product/fission-app-services.git', :branch => 'develop'
    gem 'fission-app-routes', :git => 'https://github.com/hw-product/fission-app-routes.git', :branch => 'develop'
    gem 'fission-app-chat', :git => 'https://github.com/hw-product/fission-app-chat.git', :branch => 'develop'
    gem 'fission-assets', :git => 'https://github.com/hw-product/fission-assets.git', :branch => 'develop'
    gem 'fission-nellie', :git => 'https://github.com/hw-product/fission-nellie.git', :branch => 'develop'
    gem 'fission-package-builder', :git => 'https://github.com/hw-product/fission-package-builder.git', :branch => 'develop'
    gem 'fission-repository-generator', :git => 'https://github.com/hw-product/fission-repository-generator.git', :branch => 'develop'
    gem 'fission-repository-publisher', :git => 'https://github.com/hw-product/fission-repository-publisher.git', :branch => 'develop'
    gem 'fission-stacks', :git => 'https://github.com/hw-product/fission-stacks.git', :branch => 'develop'
    gem 'sparkle_ui', :git => 'https://github.com/sparkleformation/sparkle_ui.git', :branch => 'develop'
    gem 'sparkle_builder', :git => 'https://github.com/sparkleformation/sparkle_builder.git', :branch => 'develop'
#  end
end

# source 'https://fission:8sYl7Bo0ql2OA9OPThUngg@gems.pkgd.io' do
# end

gem 'kramdown-rails'
gem 'window_rails', :git => 'git://github.com/chrisroberts/window_rails.git', :branch => 'develop'
gem 'sfn'
# List all the services available to users to allow auto registration
gem 'jackal-code-fetcher'
gem 'jackal-github-kit'
gem 'jackal-nellie'
gem 'jackal-slack'
gem 'jackal-packagecloud'

gem 'bootstrap-editable-rails'

gemspec
