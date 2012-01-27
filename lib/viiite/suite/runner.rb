module Viiite
  class Suite
    class Runner
      include Enumerable

      def initialize(suite)
        @suite = suite
      end
      
      def run(&reporter)
        return self unless reporter
        @suite.each do |bench|
          bench.run(&reporter)
        end
      end
      alias :each :run

    end # class Runner
  end # class Suite
end # module Viiite