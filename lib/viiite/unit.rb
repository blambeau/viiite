module Viiite
  module Unit

    attr_reader :path

    def run(extra = nil, reporter = nil, &block)
      extra, reporter = {}, extra unless extra.is_a?(Hash)
      reporter ||= block
      if reporter
        dup._run(extra, reporter)
      else
        to_enum(extra)
      end
    end

    private

    def to_enum(extra = {})
      Enum.new(self, extra)
    end

    class Enum
      include Enumerable

      def initialize(unit, extra)
        @unit  = unit
        @extra = extra
      end

      def each(&proc)
        return self unless proc
        @unit.run(@extra, proc)
      end

    end

  end # module Unit
end # module Viiite