class ModelBase < Risky

  class << self
    def inherited(klass)
      klass.class_eval do

        # Active library helper inclusion
        include ActiveModel::Conversion
        extend ActiveModel::Naming

        # Risky helper inclusion
        include Risky::Indexes
        include Risky::Timestamps
        include Risky::ListKeys

        def attributes
          values.keys
        end

        class << self
          alias_method :risky_links, :links

          def links(name, klass=nil)
            super(name)
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

          def link(name, klass=nil)
            super(name)
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
