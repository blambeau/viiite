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
        in_a_run do
          if @definition.arity <= 0
            instance_exec(&@definition)
          else
            @definition.call(self)
          end
        end
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
