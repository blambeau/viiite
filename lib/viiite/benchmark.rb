require 'viiite/benchmark/dsl'
module Viiite
  class Benchmark
    include Unit
    include DSL

    attr_reader :definition

    def initialize(config, path, definition)
      unless definition
        raise ArgumentError, "Benchmark definition is mandatory", caller 
      end
      super(config, path)
      @definition = definition
    end

    protected

    def _run(extra, reporter)
      @reporter = reporter
      if path and config
        relpath = path.relative_to(config.benchmark_folder)
        extra   = extra.merge(:path => relpath)
      end
      dsl_run(@definition, extra)
      @reporter = nil
    end

    def output(tuple)
      @reporter.call tuple
    end

  end # class Benchmark
end # module Viiite
