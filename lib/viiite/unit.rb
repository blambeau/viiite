module Viiite
  module Unit

    attr_reader :path

    def run(reporter = nil, &block)
      reporter ||= block
      return to_enum unless reporter
      dup._run(reporter)
    end

    private

    def to_enum
      Enum.new(self)
    end

    class Enum
      include Enumerable
      def initialize(unit)
        @unit = unit
      end
      def each(&proc)
        return self unless proc
        @unit.run(proc)
      end
    end

  end # module Unit
end # module Viiite