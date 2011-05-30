#
# Benchmarking and complexity analyzer utility
#
module Bench
  
  VERSION = "1.0.0".freeze

  def self.define(&block)
    BenchCase.new(block)
  end
  
  class BenchCase
    include Enumerable
    
    # Creates a benchmarking case instance
    def initialize(defn)
      @defn = defn
    end
    
    # Outputs a benchmark measure
    def output(measure)
      @reporter.call @stack.last.merge(:measure => measure)
    end
  
    # Sets a variation point  
    def variation_point(name, value, &block)
      if block
        @stack << @stack.last.merge(name => value)
        block.call(self)
        @stack.pop
      else
        @stack.last[name] = value
      end
    end
    
    def run(&block)
      output Benchmark.measure{ block.call(self) }
    end

    def execute(&reporter)
      @stack, @reporter = [ {} ], reporter
      self.instance_eval &@defn
      @stack, @reporter = nil, nil
    end
    alias :each :execute
    
  end # class BenchCase
  
end # module Bench
require "bench/loader"
require "bench/ext/benchmark"
require "bench/aggregator"
require "bench/summarize"
