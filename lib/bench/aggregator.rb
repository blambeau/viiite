module Bench

  # Provides an aggregation function
  class Aggregator
  
    # Initial value
    attr_reader :init_value
  
    # Creates an aggregator instance
    def initialize(init_value, collector, finalizer = nil)
      @init_value = init_value
      @collector = collector
      @finalizer = finalizer
    end
  
    # Aggregates a tuple on a previous memo value
    def collect(memo, value)
      @collector.call(memo, value)
    end
  
    # Finalizes the memo as the actual computation value
    def finalize(memo)
      @finalizer.nil? ? memo : @finalizer.call(memo)
    end
    
    # Collects all tuples then finalize
    def <<(values)
      finalize values.inject(init_value){|memo,v| collect(memo, v)}
    end
    
    # Factors a counting aggregator
    def self.count
      @count ||= Aggregator.new(0, lambda{|memo, val| memo + 1})
    end
    
    # Factors a sum aggregator
    def self.sum(attribute = nil)
      case attribute
      when Symbol
        Aggregator.new(0, lambda{|memo, val| memo + val[attribute]})
      when nil
        @sum ||= Aggregator.new(0, lambda{|memo, val| memo + val})
      else
        raise ArgumentError, "Unrecognized argument: #{attribute} (#{attribute.class})"
      end
    end
    
    def self.avg(attribute = nil)
      case attribute
      when Symbol
        Aggregator.new(
          [0, 0], 
          lambda{|memo, val| [ memo[0] + 1, memo[1] + val[attribute] ]},
          lambda{|memo| memo[0] == 0 ? 0 : memo[1] / memo[0]}
        )
      when nil
        @avg ||= Aggregator.new(
          [0, 0], 
          lambda{|memo, val| [ memo[0] + 1, memo[1] + val ]},
          lambda{|memo| memo[0] == 0 ? 0 : memo[1] / memo[0]}
        )
      else
        raise ArgumentError, "Unrecognized argument: #{attribute} (#{attribute.class})"
      end
    end
  
  end # class Aggregator

end # module Bench