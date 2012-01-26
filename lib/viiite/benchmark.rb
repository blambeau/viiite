require 'viiite/benchmark/dsl'
require 'viiite/benchmark/runner'
module Viiite
  class Benchmark

    attr_reader :definition

    def initialize(definition)
      @definition = definition
    end

    @benchmarks = []
    def self.new(arg, *others)
      case arg
      when String, Path
        load Path(arg).expand
        @benchmarks.pop
      when IO, StringIO
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

  end # class Benchmark
end # module Viiite
