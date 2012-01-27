module Viiite
  class Reporter

    attr_reader :config

    def initialize(config)
      @config = config
    end

    def report(unit)
      case unit
      when Suite
        unit.each.run self
      else
        unit.each &method(:call)
      end
    end

    def ios
      [config.stdout]
    end

    def call(tuple)
      literal = Alf::Tools.to_ruby_literal(tuple)
      ios.each do |io|
        io << literal << "\n"  
      end
    end

  end # class Reporter
end # module Viiite