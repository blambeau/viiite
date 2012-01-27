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

      def dsl_run(defn, subject = self)
        @current_tuple = {}
        if defn.arity <= 0
          subject.instance_exec(&defn)
        else
          defn.call(self)
        end
        @current_tuple = nil
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
        if block
          GC.start
          hash = hash.merge(:tms => Viiite.measure(&block))
        end
        with(hash){ output current_tuple.dup }
      end

    end # module DSL
  end # class Benchmark
end # module Viiite
