require 'viiite/benchmark/dsl'
require 'viiite/benchmark/runner'
module Viiite
  class Benchmark

    attr_reader :path
    attr_reader :definition

    def initialize(definition)
      @definition = definition
    end

    @benchmarks = []
    def self.new(arg, *others)
      case arg
      when String, Path
        @benchmarks = []
        load(path = Path(arg).expand)
        bench = @benchmarks.pop
        bench.send(:path=, path) if bench
        bench
      when IO, StringIO
        warn "Building Benchmarks from IO objects is deprecated"
        eval(arg.read, TOPLEVEL_BINDING)
        @benchmarks.pop
      else
        bench = super(arg)
        @benchmarks << bench
        bench
      end
    end

    def runner
      Runner.new(definition)
    end

    def run(&reporter)
      runner.call(reporter)
    end

    private

    attr_writer :path

  end # class Benchmark
end # module Viiite
