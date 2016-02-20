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
require 'rails_javascript_helpers'

module FissionApp
  # @return [String] default internal name of root product
  DEFAULT_PRODUCT_NAME = 'fission'

  extend RailsJavaScriptHelpers

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
    if(event_name.size == 1 && event_name.first.is_a?(Regexp))
      e_name = event_name.first
    else
      e_name = event_name.map(&:to_s).push('fission-app').join('.')
    end
    ActiveSupport::Notifications.subscribe(e_name, &block)
    true
  end

  # Generate data structure string for auto popups
  #
  # @param data [Hash]
  # @option [String] :dom_id ID of item to attach popup
  # @option [String] :title Title of popup
  # @option [String] :content Content of popup
  # @option [String] :location Placement of popup
  # @option [Hash] :condition Condition to display (:name and :args)
  # @option [Integer] :duration Number of seconds to display
  # @option [Integer] :delay Number of seconds to delay display
  # @option [String] :id Notification identifier
  # @return String
  def self.auto_popup_formatter(data)
    data = data.to_smash
    data[:location] ||= 'auto'
    data[:delay] ||= 1
    data.set(:condition, :name, 'always_true') unless data.get(:condition, :name)
    "auto_popups['items'].push(#{format_type_to_js(data)});".html_safe
  end

end
