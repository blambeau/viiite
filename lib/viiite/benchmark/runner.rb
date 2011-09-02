module Viiite
  class Benchmark
    module Runner

      def with(hash)
        if block_given?
          org_tuple = @tuple
          @tuple = org_tuple.merge(hash)
          res = yield
          @tuple = org_tuple
          res
        else
          @tuple.merge!(hash)
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
        hash = {:bench => hash.to_sym} unless hash.is_a?(Hash)
        with(hash) {
          GC.start
          tms = Viiite.measure(&block)
          with(:tms => tms){ output }
        }
      end

      protected

      def _each(&reporter)
        @tuple, @reporter = {}, reporter
        self.instance_eval(&definition)
        @tuple, @reporter = nil, nil
      end

      def output
        @reporter.call @tuple.dup
      end

    end # module Runner
  end # class Benchmark
end # module Viiite
