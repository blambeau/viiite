module Viiite
  class Benchmark
    class Runner
      include Enumerable
      include DSL

      def initialize(definition)
        @definition = definition
      end

      def each(&reporter)
        return self unless reporter
        @reporter = reporter
        dsl_run(@definition)
        @reporter = nil
      end

      protected

      def output(tuple)
        @reporter.call tuple
      end

    end # class Runner
  end # class Benchmark
end # module Viiite
