module Viiite
  class Benchmark
    class Runner
      include DSL

      def initialize(definition)
        @definition = definition
      end

      def call(reporter)
        @reporter = reporter
        in_a_run do
          if @definition.arity <= 0
            instance_exec(&@definition)
          else
            @definition.call(self)
          end
        end
        @reporter = nil
      end

      protected

      def output(tuple)
        @reporter.call tuple
      end

    end # class Runner
  end # class Benchmark
end # module Viiite
