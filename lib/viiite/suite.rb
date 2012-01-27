module Viiite
  class Suite
    include Unit

    attr_reader :config

    def initialize(config, files = config.benchmark_folder)
      @config = config
      @files  = case files
      when Path, String
        [ Path(files).expand ]
      when Array
        files.map{|f| Path(f).expand}
      end
    end

    def benchmark_files
      benchmarks.map(&:path)
    end

    protected
    attr_reader :files

    def benchmarks
      files.map{|file| load_one(file)}.flatten
    end

    def load_one(file)
      if file.file?
        bench = Viiite.bench(config, file)
        warn "No benchmark found in #{file}" unless bench
        [ bench ].compact
      else
        file.glob(config.benchmark_pattern).
             sort.
             map{|file| load_one(file)}.
             compact
      end
    end

    def _run(extra, reporter)
      benchmarks.each do |unit|
        unit.run(extra, reporter)
      end
    end

  end # class Suite
end # module Viiite