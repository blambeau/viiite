module Viiite
  class Benchmark
    module Runner
      include DSL

      protected

      def _each(&reporter)
        @reporter = reporter
        in_a_run do
          if definition.arity <= 0
            instance_exec(&definition)
          else
            definition.call(self)
          end
        end
        @reporter = nil
      end

      def output(tuple)
        @reporter.call tuple
      end

    end # module Runner
  end # class Benchmark
end # module Viiite
