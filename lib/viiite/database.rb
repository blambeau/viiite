module Viiite
  class Database
    
    attr_reader :config
    
    def initialize(config)
      @config = config
    end
    
    def benchmarks
      tuples = benchmark_files.map{|f|
        {:path => f, :benchmark => Benchmark.new(f)}
      }
      Alf::Relation.coerce(tuples)
    end
    
    private 
    
    def benchmark_files
      c = config
      c.benchmark_folder.glob(c.benchmark_pattern)
    end
    
  end # class Database
end # module Viiite