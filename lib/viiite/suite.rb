module Viiite
  class Suite
    include Unit

    attr_reader :config

    def initialize(config, files = config.benchmark_folder)
      @config = config
      @files  = Array(files).map{|f| Path(f).expand}
    end

    def benchmark_files
      benchmarks.map(&:path)
    end

    protected
    attr_reader :files

    def benchmarks
      files.map(&method(:load_one)).flatten.compact
    end

    def load_one(file)
      if file.file?
        unless bench = Viiite.bench(config, file)
          warn "No benchmark found in #{file}"
        end
        [ bench ]
      else
        file.glob(config.benchmark_pattern).
             sort.
             map{|file| load_one(file)}
      end
    end

    def _run(extra, reporter)
      benchmarks.each do |unit|
        unit.run(extra, reporter)
      end
    end

  end # class Suite
end # module Viiite