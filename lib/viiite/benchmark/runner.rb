module Viiite
  class Benchmark
    class Runner
      include Enumerable
      include DSL

      def initialize(definition)
        @definition = definition
      end

      def call(reporter)
        @reporter = reporter
        dsl_run(@definition)
        @reporter = nil
      end

      def run(&reporter)
        return self unless reporter
        call(reporter)
      end
      alias :each :run

      protected

      def output(tuple)
        @reporter.call tuple
      end

    end # class Runner
  end # class Benchmark
end # module Viiite
