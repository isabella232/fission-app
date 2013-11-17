require 'securerandom'
require 'ostruct'
require 'risky'

class ModelBase < Risky

  # Execute these things on inclusion

  class << self
    def inherited(klass)
      klass.class_eval do

        # Active library helper inclusion
        include ActiveModel::Validations
        include ActiveModel::Conversion
        extend ActiveModel::Naming

        # Risky helper inclusion
        include Risky::Indexes
        include Risky::Timestamps
        include Risky::ListKeys

        class << self

          def table_name
            self.name.underscore.pluralize
          end

          def attribute_names
            values.keys
          end

          def display_attributes
            []
          end

          def find(key)
            self[key]
          end

          # raw search
          def search(query)
            self.riak.search(bucket.name, query)
          end

          # stub
          def restrict(user)
            all
          end

          def associations
            @associations || []
          end

          alias_method :risky_links, :links

          def links(name, klass=nil)
            @associations ||= {}.with_indifferent_access
            @associations[name] = {:class => klass, :style => :many}
            risky_links(name)
            if(klass)
              class_eval do
                alias_method "risky_#{name}".to_sym,  name.to_sym
                define_method(name) do
                  send("risky_#{name}".to_sym).map do |k|
                    klass[k]
                  end
                end
              end
            end
          end

          alias_method :risky_link, :link

          def link(name, klass=nil)
            @associations ||= {}.with_indifferent_access
            @associations[name] = {:class => klass, :style => :one}
            risky_link(name)
            if(klass)
              class_eval do
                alias_method "risky_#{name}".to_sym, name.to_sym
                define_method(name) do
                  klass[send("risky_#{name}".to_sym)]
                end
              end
            end
          end

        end
      end
    end
  end

  # customizations and overrides

  attr_reader :run_state

  def initialize(key=nil)
    @run_state = OpenStruct.new
    key ||= SecureRandom.uuid
    super
  end

  def values
    super.with_indifferent_access
  end

  def []=(k,v)
    values[k] = v
  end

  def [](k)
    values[k]
  end

  def persisted?
    true
  end

  def id
    begin
      super
    rescue TypeError
      raise unless new?
      ''
    end
  end

end
