require 'viiite/suite/runner'
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
      Runner.new(self).run(&reporter)
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

    private

    def load_one(file)
      bench = Benchmark.new(file)
      warn "No benchmark found in #{file}" unless bench
      bench
    end

  end # class Suite
end # module Viiite