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
      extra = extra.merge(:path => path) if path
      dsl_run(@definition, extra)
      @reporter = nil
    end

    def output(tuple)
      @reporter.call tuple
    end

  end # class Benchmark
end # module Viiite
