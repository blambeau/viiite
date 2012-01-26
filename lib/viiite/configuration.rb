module Viiite
  class Configuration
    
    module ClassMethods
      
      def attribute(name, type, default)
        var = "@#{name}".to_sym
        install_getter(name, var, type, default)
        install_setter(name, var, type, default)
      end
      
      private
      
      def install_getter(name, var, type, default)
        define_method name do 
          instance_variable_set(var, default) unless instance_variable_defined?(var)
          instance_variable_get(var)
        end
      end
      
      def install_setter(name, var, type, default)
        define_method "#{name}=" do |val|
          instance_variable_set(var, Coercions.apply(val, type))
        end
      end

    end
    extend(ClassMethods)
    
    attribute :benchmark_folder,  Path,    "benchmarks"
    attribute :benchmark_pattern, String,  "**/*.rb"
    attribute :cache,             Boolean, true
    
  end # class Configuration
end # module Viiite