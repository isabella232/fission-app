require 'fission-data'
require 'fission-app/version'
require 'fission-app/errors'
require 'fission-app/commons'

require 'cells'
require 'will_paginate'
require 'will_paginate/array'
require 'will_paginate/sequel'
require 'will_paginate-bootstrap'
require 'content_for_in_controllers'

module FissionApp
  # @return [String] default internal name of root product
  DEFAULT_PRODUCT_NAME = 'fission'

  # If product does not exist via internal name lookup, create the
  # product
  #
  # @param internal_name [String]
  # @param display_name [String]
  # @return [Fission::Data::Models::Product]
  def self.init_product(internal_name, display_name=nil)
    internal_name = internal_name.to_s
    if(display_name.nil? && internal_name.respond_to?(:humanize))
      display_name = internal_name.humanize
    end
    existing = Fission::Data::Models::Product.find_by_internal_name(internal_name)
    unless(existing)
      Fission::Data::Models::Product.create(
        :internal_name => internal_name,
        :name => display_name
      )
    else
      existing
    end
  end

  # Subscribe to a fission app event
  #
  # @param event_name [String, Symbol] name of event
  # @yield block to process event
  # @return [TrueClass]
  def self.subscribe(*event_name, &block)
    unless(block)
      raise ArgumentError.new 'Block is required for processing event!'
    end
    ActiveSupport::Notifications.subscribe("#{event_name.map(&:to_s).join('.')}.fission_app", &block)
    true
  end

end
