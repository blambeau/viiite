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
      measure = Benchmark.measure{ block.call(self) }
      report :stime => measure.stime,
             :utime => measure.utime,
             :total => measure.total,
             :real  => measure.real
      output
    end

    def execute(&reporter)
      @stack, @reporter = [ {} ], reporter
      self.instance_eval &@defn
      @stack, @reporter = nil, nil
    end
    alias :each :execute
    
    private    

    def report(hash)
      @stack.last.merge!(hash)
    end

    def output
      @reporter.call @stack.last.dup
    end

  end # class BenchCase
  
end # module Bench
require "bench/loader"
require "bench/ext/benchmark"
require "bench/aggregator"
require "bench/summarize"
