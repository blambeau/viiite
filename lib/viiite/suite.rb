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

    def run(reporter = nil, &block)
      reporter ||= block
      if reporter and reporter.respond_to?(:report)
        reporter.report(self)
      elsif reporter
        runner.each(&reporter)
      else
        runner
      end
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

    def runner
      Runner.new(self)
    end

  end # class Suite
end # module Viiite