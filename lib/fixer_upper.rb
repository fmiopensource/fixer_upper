#FixerUpper
#Fixer::Upper
module Fixer #:nodoc:
  module Upper #:nodoc:

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def fixer_upper(options={})
        extend Fixer::Upper::InstanceMethods
        exclude_both = options.key?(:exclude)      ? options[:exclude]      : []
        exclude_gets = options.key?(:exclude_gets) ? options[:exclude_gets] : []
        exclude_sets = options.key?(:exclude_sets) ? options[:exclude_sets] : []

        create_props(exclude_both, exclude_gets, exclude_sets)
      end
    end

    module InstanceMethods

      def create_getter_method(name, orig_name)
        define_method(name.to_sym) { self.send(orig_name.to_sym) }
      end

      def create_setter_method(name, orig_name)
        define_method("#{name}=".to_sym) { |value| self.send("#{orig_name}=".to_sym, value) }
      end

      def create_props(exclude_both, exclude_gets, exclude_sets)
        self.column_names.each do |column|
          new_prop = column.underscore
          if !(new_prop == column) and !(exclude_both.include?(column))
            create_getter_method(new_prop, column) unless exclude_gets.include?(column)
            create_setter_method(new_prop, column) unless exclude_sets.include?(column)
          end
        end
      end

    end

  end
end