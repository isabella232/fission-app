module FissionApp
  class Version
    attr_accessor :codename
    attr_reader :version

    def initialize(version, codename)
      @codename = codename
      @version = Gem::Version.new(version)
    end

    def method_missing(*args)
      version.send(*args)
    end
  end
  VERSION = Version.new('0.1.8', "I'm the first one at work. A new low.")
end
