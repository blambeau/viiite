module Viiite
  module Reporter
    class Rash

      def initialize(io = $stdout)
        @io = io
      end

      def report(bench_or_suite)
        Alf::Renderer.rash(bench_or_suite.run).execute(@io)
      end

      def call(tuple)
        @io << Alf::Tools.to_ruby_literal(tuple) << "\n"
      end

    end # class Rash
  end # module Reporter
end # module Viiite