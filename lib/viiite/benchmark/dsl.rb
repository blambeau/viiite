module Viiite
  class Benchmark
    #
    # Domain Specific Language for specifying the Benchmark
    #
    # This module expects an `output` method.
    #
    module DSL
      
      def with(hash)
        if block_given?
          old_tuple, @tuple = @tuple, @tuple.merge(hash)
          res = yield
          @tuple = old_tuple
          res
        else
          @tuple.merge!(hash)
        end
      end

      def range_over(range, name = nil, &block)
        name ||= block.parameters.first.last if RUBY_VERSION > '1.9'
        raise ArgumentError, "You must specify a name (explicitely in 1.8)" unless name
        range.each do |value|
          with(name => value) { yield value }
        end
      end

      def variation_point(name, value, &proc)
        with({name => value}, &proc)
      end

      def report(hash = {}, &block)
        hash = {:bench => hash.to_sym} unless hash.is_a?(Hash)
        with(hash) {
          GC.start
          with(:tms => Viiite.measure(&block)){ 
            output
          }
        }
      end
      
    end # module DSL
  end # class Benchmark
end # module Viiite
