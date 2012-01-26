module Viiite
  class Database
    
    attr_reader :config
    
    def initialize(config)
      @config = config
    end
    
    def benchmarks
      folder = config.benchmark_folder
      tuples = benchmark_files.map{|f|
        {:name => f.relative_to(folder).without_extension.to_s, :path => f}
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
