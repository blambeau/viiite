require 'viiite/benchmark/runner'
module Viiite
  class Benchmark
    include Runner
    include Alf::Iterator

    attr_reader :definition

    def initialize(definition)
      @definition = definition
    end

    @benchmarks = []
    def self.new(arg, *others)
      case arg
      when String, EPath
        load File.expand_path(arg)
        @benchmarks.pop
      when IO, StringIO
        Kernel.eval(arg.read, TOPLEVEL_BINDING)
        @benchmarks.pop
      else
        bench = super(arg)
        @benchmarks << bench
        bench
      end
    end

    def each(&reporter)
      self.dup._each(&reporter)
    end

    Alf::Reader.register(:viiite, [".viiite", ".rb"], self)
  end # class Benchmark
end # module Viiite
