module Viiite
  class Database

    attr_reader :config

    def initialize(config)
      @config = config
    end

    def benchmarks(pwd = nil)
      folder = config.benchmark_folder
      tuples = benchmark_files.map{|f|
        {:name => f.relative_to(folder).without_extension.to_s, 
         :path => pwd ? f.relative_to(pwd) : f}
      }
      Alf::Relation.coerce(tuples)
    end

    def benchmark_result(tuple)
      if tuple.is_a?(String)
        tuple = benchmarks.restrict(:name => tuple).to_a.first
      end
      if tuple and cache=config.cache_folder
        result_file = cache/"#{tuple[:name]}.rash"
        if result_file.file?
          Alf::Reader.rash(result_file.to_s)
        else
          Alf::Relation::DUM
        end
      end
    end

    private

    def benchmark_files
      c = config
      c.benchmark_folder.glob(c.benchmark_pattern)
    end

  end # class Database
end # module Viiite
