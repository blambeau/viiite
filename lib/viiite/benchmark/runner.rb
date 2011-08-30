module Viiite
  class Benchmark
    module Runner

      def with(hash)
        if block_given?
          @stack << @stack.last.merge(hash)
          res = yield
          @stack.pop
          res
        else
          @stack.last.merge!(hash)
        end
      end

      def range_over(range, name)
        range.each do |value|
          with(name => value){ yield value }
        end
      end

      def variation_point(name, value, &proc)
        h = {name => value}
        with(h, &proc)
      end

      def report(hash = {}, &block)
        hash = {:bench => hash} unless hash.is_a?(Hash)
        with(hash) {
          GC.start
          tms = Viiite.measure{block.call}
          with(:tms => tms){ output }
        }
      end

      protected

      def _each(&reporter)
        @stack, @reporter = [ {} ], reporter
        self.instance_eval(&definition)
        @stack, @reporter = nil, nil
      end

      def output
        @reporter.call @stack.last.dup
      end

    end # module Runner
  end # class Benchmark
end # module Viiite
