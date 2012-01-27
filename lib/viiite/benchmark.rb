require 'viiite/benchmark/dsl'
module Viiite
  class Benchmark
    include Unit
    include DSL

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
      else
        bench = super(arg)
        @benchmarks << bench
        bench
      end
    end

    protected
    attr_writer :path

    def _run(extra, reporter)
      @reporter = reporter
      extra = extra.merge(:path => path) if path
      dsl_run(@definition, extra)
      @reporter = nil
    end

    def output(tuple)
      @reporter.call tuple
    end

  end # class Benchmark
end # module Viiite
