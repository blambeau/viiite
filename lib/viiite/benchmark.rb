require 'viiite/benchmark/runner'
module Viiite
  class Benchmark
    include Runner
    include Alf::Iterator

    attr_reader :definition

    def initialize(definition)
      @definition = definition
    end
    
    def each(&reporter)
      self.dup._each(&reporter)
    end

  end # class Benchmark
end # module Viiite
