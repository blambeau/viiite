module Viiite
  class Suite
    include Unit

    attr_reader :config
    attr_reader :benchmarks

    def initialize(config, benchmarks)
      @config     = config
      @benchmarks = benchmarks
    end
    
    def files
      benchmarks.map(&:path)
    end

    def to_s
      fs = files.map{|f| 
        {:path => f.expand.relative_to(config.pwd.expand)} 
      }
      Alf::Relation.coerce(fs).to_s
    end

    protected

    def _run(extra, reporter)
      benchmarks.each do |unit|
        unit.run(extra, reporter)
      end
    end

  end # class Suite
end # module Viiite