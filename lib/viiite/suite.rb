module Viiite
  class Suite
    include Enumerable

    attr_reader :config
    attr_reader :path

    def initialize(config, path = config.benchmark_folder)
      @config = config
      @path   = path
    end

    def run(&reporter)
      each do |bench|
        bench.run(&reporter)
      end
    end

    def each(&proc)
      benchmarks = if path.file?
        [ load_one(path) ]
      else
        path.glob(config.benchmark_pattern).
             map{|file| load_one(file)}
      end
      benchmarks.compact.each(&proc)
    end

    def empty?
      to_a.empty?
    end

    private

    def load_one(file)
      bench = Benchmark.new(file)
      warn "No benchmark found in #{file}" unless bench
      bench
    end

  end # class Suite
end # module Viiite