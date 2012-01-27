module Viiite
  class Suite
    include Unit
    include Enumerable

    def initialize(config, path = config.benchmark_folder)
      super
    end

    def each(&proc)
      benchmarks = if path.file?
        [ load_one(path) ]
      else
        path.glob(config.benchmark_pattern).
             sort.
             map{|file| load_one(file)}
      end
      benchmarks.compact.each(&proc)
    end

    def files
      map(&:path)
    end

    def empty?
      to_a.empty?
    end

    protected

    def load_one(file)
      bench = Viiite.bench(config, file)
      warn "No benchmark found in #{file}" unless bench
      bench
    end

    def _run(extra, reporter)
      each do |bench|
        bench.run(extra, reporter)
      end
    end

  end # class Suite
end # module Viiite