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
  VERSION = Version.new('0.1.63', "Come on, universe, you big, mostly empty wuss! Give me all the juice you got!")
end
