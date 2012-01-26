module Viiite
  class Benchmark
    #
    # Domain Specific Language for specifying a Benchmark.
    #
    # This module expects an `output` method that outputs the computation tuple
    # at each step.
    #
    module DSL
      
      attr_reader :current_tuple
      
      def in_a_run
        @current_tuple = {}
        res = yield
        @current_tuple = nil
        res
      end
      
      def with(hash)
        if block_given?
          old_tuple, @current_tuple = current_tuple, current_tuple.merge(hash)
          res = yield
          @current_tuple = old_tuple
          res
        else
          current_tuple.merge!(hash)
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
            output current_tuple.dup
          }
        }
      end
      
      private
      
      # Outputs `tuple`, result of the current benchmark step
      def output(tuple)
      end
      undef :output
      
    end # module DSL
  end # class Benchmark
end # module Viiite
