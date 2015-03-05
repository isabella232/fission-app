# Load the Rails application.
require File.expand_path('../application', __FILE__)

unless(ENV['RAILS_ASSETS_PRECOMPILE'])
  FissionApp::Application.initialize!
else
  class FissionApp::Application
    def run_initializers(group=:default, *args)
      return if instance_variable_defined?(:@ran)
      initializers.tsort_each do |initializer|
        begin
          initializer.run(*args) if initializer.belongs_to?(group)
        rescue
        end
      end
      @ran = true
    end
  end
  FissionApp::Application.initialize!
end
