$:.unshift File.join(File.expand_path(File.dirname(__FILE__)), 'lib')
require 'fission-app/version'
Gem::Specification.new do |s|
  s.name = 'fission-app'
  s.version = FissionApp::VERSION.version
  s.summary = 'Fission Frontend'
  s.author = 'Heavywater'
  s.email = 'fission@hw-ops.com'
  s.homepage = 'http://github.com/heavywater/fission-app'
  s.description = 'Fission Frontend'
  s.require_path = 'lib'
  s.add_dependency 'fission-data'
  s.add_dependency 'will_paginate'
  s.add_dependency 'will_paginate-bootstrap'
  s.add_dependency 'content_for_in_controllers'
  s.add_dependency 'cells'
  s.executables << 'fission-app'
  s.files = Dir['**/*']
end
