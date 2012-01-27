module Viiite
  class Database

    attr_reader :config

    def initialize(config)
      @config = config
    end

    def suite
      Alf::Relation.coerce build_suite(config.benchmark_folder, [])
    end

    def benchmarks
      tuples = benchmark_files(config.benchmark_folder).map do |t|
        {:name => benchmark_name(t[:path])}.merge(t)
      end
      Alf::Relation.coerce tuples
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

    ###
    
    def build_suite(current, tuples = [])
      tuples << suite_tuple_for(current)
      if current.directory?
        current.glob('*').sort.each do |sub|
          build_suite(sub, tuples)
        end
      end
      tuples
    end

    def suite_tuple_for(file)
      {:name  => benchmark_name(file),
       :files => benchmark_files(file)}
    end

    def benchmark_files(dir)
      tuples = if dir.file?
        [
          {:path => benchmark_path(dir)}
        ]
      else
        dir.glob(config.benchmark_pattern).sort.map{|f|
          {:path => benchmark_path(f) }
        }
      end
      Alf::Relation.coerce(tuples)
    end

    def benchmark_path(file)
      config.pwd ? file.relative_to(config.pwd) : file
    end

    def benchmark_name(file)
      file = (config.pwd.expand/file) unless file.absolute?
      file = file.relative_to(config.benchmark_folder.expand)
      file.without_extension.to_s
    end

  end # class Database
end # module Viiite
