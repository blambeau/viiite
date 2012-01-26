module Viiite
  class Benchmark
    module Runner
      include DSL

      protected

      def _each(&reporter)
        @tuple, @reporter = {}, reporter
        if definition.arity <= 0
          instance_exec(&definition)
        else
          definition.call(self)
        end
        @tuple, @reporter = nil, nil
      end

      def output
        @reporter.call @tuple.dup
      end

    end # module Runner
  end # class Benchmark
end # module Viiite
