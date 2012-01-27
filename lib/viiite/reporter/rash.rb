module Viiite
  module Reporter
    class Rash
      include Reporter

      def initialize(io = $stdout, delegate = nil)
        @io = io
        @delegate = delegate
      end

      def call(tuple)
        @io << Alf::Tools.to_ruby_literal(tuple) << "\n"
        @delegate.call(tuple) if @delegate
      end

    end # class Rash
  end # module Reporter
end # module Viiite