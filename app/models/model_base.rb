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
            unless(@associations)
              @associations = {}.with_indifferent_access
            end
            @associations
          end

          alias_method :risky_links, :links

          def links(name, klass=nil, args={})
            associations[name] = {
              :class => klass,
              :style => :many,
              :reverse => args[:to],
              :dependent => args[:dependent]
            }
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

          def link(name, klass=nil, args={})
            associations[name] = {
              :class => klass,
              :style => :one,
              :reverse => args[:to],
              :dependent => args[:dependent]
            }
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

  def after_delete
    self.class.associations.each do |attribute, info|
      if(info[:reverse])
        remote_association = info[:class].associations[info[:reverse]]
        if(remote_association[:dependent])
          remote_args = [:delete]
        elsif(remote_association[:style] == :many)
          remote_args = ["remove_#{info[:reverse]}", self]
        else
          remote_args = ["#{info[:reverse]}=", nil]
        end
        case info[:style]
        when :many
          self.send(attribute).each do |instance|
            if(instance)
              instance.send(*remote_args)
              instance.save unless remote_args.first == :delete
            end
          end
        when :one
          instance = self.send(attribute)
          if(instance)
            instance.send(*remote_args)
            instance.save unless remote_args.first == :delete
          end
        end
      end
    end
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
