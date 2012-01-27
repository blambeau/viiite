module Viiite
  class Benchmark
    class Runner
      include DSL
      include Alf::Iterator

      def initialize(definition)
        @definition = definition
      end

      def call(reporter)
        @reporter = reporter
        dsl_run(@definition)
        @reporter = nil
      end

      def each(&reporter)
        call(reporter)
      end

      protected

      def output(tuple)
        @reporter.call tuple
      end

    end # class Runner
  end # class Benchmark
end # module Viiite
