module Restrictor

  extend ActiveSupport::Concern

  included do
    include FissionApp::Errors

    # TODO: LOL add some docs!
    scope(:restrict,
      lambda{|user|
        base_scope = self.all
        collection = {:joins => [], :keys => []}
        [user, user.current_account].each do |instance|
          next if self == instance.class
          inst_class = instance.class.name
          base_scope = self.all
          self.reflect_on_all_associations.each do |assoc|
            class_name = assoc.options[:class_name] || assoc.name.to_s.classify
            if(class_name == inst_class)
              if(assoc.macro == :belongs_to)
                collection[:keys] << {
                  :table_name => self.table_name,
                  :key => assoc.foreign_key,
                  :instance => instance
                }
              else
                if(assoc.is_a?(ActiveRecord::Reflection::ThroughReflection))
                  collection[:joins] << {:assoc => assoc.through_reflection.name}
                  collection[:keys] << {
                    :table_name => assoc.through_reflection.klass.table_name,
                    :key => assoc.foreign_key,
                    :instance => instance
                  }
                else
                  collection[:joins] << {:assoc => assoc.name}
                  collection[:keys] << {
                    :table_name => assoc.table_name,
                    :key => assoc.foreign_key,
                    :instance => instance
                  }
                end
              end
            end
          end
        end
        unless(collection[:joins].empty?)
          collection[:joins].each do |join_info|
            base_scope = base_scope.joins do
              self.__send__(*[join_info[:assoc], join_info[:class]].compact).outer
            end
          end
        end
        unless(collection[:keys].empty?)
          base_scope = base_scope.where do
            _where_base = self
            collection[:keys].inject(_where_base) do |memo, k|
              if(k == collection[:keys].first)
                memo.__send__(k[:table_name]).__send__(k[:key]).__send__('==', k[:instance].id)
              else
                memo.__send__('|', _where_base.__send__(k[:table_name]).__send__(k[:key]).__send__('==', k[:instance].id))
              end
            end
          end
        end
        base_scope
      }
    )

  end

end
