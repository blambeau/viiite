module Viiite
  class Suite
    class Runner
      include Enumerable

      def initialize(suite)
        @suite = suite
      end

      def each(&reporter)
        return self unless reporter
        @suite.each do |bench|
          bench.run(&reporter)
        end
      end

    end # class Runner
  end # class Suite
end # module Viiite