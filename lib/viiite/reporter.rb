module Viiite
  class Reporter

    attr_reader :config

    def initialize(config)
      @config = config
      @ios    = [config.stdout].compact
    end

    def report(unit)
      case unit
      when Benchmark
        with_ios(unit) do 
          unit.run.each &method(:call)
        end
      when Suite
        unit.each.run self
      else
        raise ArgumentError, "Unable to report on #{unit}"
      end
    end

    def call(tuple)
      literal = Alf::Tools.to_ruby_literal(tuple)
      @ios.each do |io|
        io << literal << "\n"  
      end
    end

    private

    def with_ios(bench)
      if cache = config.cache_file_for(bench)
        cache.open('a') do |io|
          @ios.push(io)
          yield
          @ios.pop
        end
      else
        yield
      end
    end

  end # class Reporter
end # module Viiite