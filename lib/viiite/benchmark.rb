require 'viiite/benchmark/dsl'
require 'viiite/benchmark/runner'
module Viiite
  class Benchmark
    include Unit

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

    private

    attr_writer :path
    
    def runner
      Runner.new(definition)
    end

  end # class Benchmark
end # module Viiite
