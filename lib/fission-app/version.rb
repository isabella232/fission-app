module FissionApp
  class Version < Gem::Version
    attr_reader :codename
    def initialize(version, codename)
      super(version)
      @codename = codename
    end
  end
  VERSION = Version.new('0.1.0', 'Shut up and take my money')
end
