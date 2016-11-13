module Viiite
  class Configuration

    module ClassMethods

      def attribute(name, type, default)
        var = "@#{name}".to_sym
        install_getter(name, var, type, default)
        install_setter(name, var, type, default)
      end

      def getter(name, type, default)
        var = "@#{name}".to_sym
        install_getter(name, var, type, default)
      end

      private

      def install_getter(name, var, type, default)
        define_method name do 
          instance_variable_set(var, default) unless instance_variable_defined?(var)
          value = instance_variable_get(var)
          value = value.is_a?(Proc) ? value.call(self) : value
          Coercions.apply(value, type)
        end
      end

      def install_setter(name, var, type, default)
        define_method "#{name}=" do |val|
          instance_variable_set(var, val)
        end
      end

    end
    extend(ClassMethods)

    def initialize
      yield(self) if block_given?
    end

    ValidOut = lambda{|x| x.respond_to?(:<<) }

    attribute :benchmark_folder,  Path,     "benchmarks"
    attribute :benchmark_pattern, String,   "**/*.rb"
    attribute :cache_folder,      Path,     Proc.new{|c| c.benchmark_folder/".cache" }
    attribute :stdout,            ValidOut, $stdout

    def cache_enabled?
      !!cache_folder
    end

    def cache_file_for(path)
      return nil unless cache_folder
      path = path.path if path.respond_to?(:path)
      return nil unless path
      path = Path(path).expand
      path = path.relative_to(benchmark_folder.expand)
      (cache_folder/path).sub_ext(".rash")
    end

  end # class Configuration
end # module Viiite