#
# Benchmarking and complexity analyzer utility
#
module Bench
  
  VERSION = "1.0.0".freeze
  
  def self.run(db_file = nil) 
    bench_case = BenchCase.new(db_file)
    yield bench_case
  end
  
  class BenchCase
    
    # Number of runs to make
    attr_accessor :runs
    
    # Creates a benchmarking case instance
    def initialize(db_file = nil)
      @db_file = db_file
      @stack = [ Hash.new ]
      @measures = [ ]
    end
    
    # Outputs a benchmark measure
    def output(hash)
      @measures << [ hash ]
    end
  
    # Sets a variation point  
    def variation_point(name, value)
      @stack.last[name] = value
      if block_given?
        @stack << @stack.last.dup  
        yield
        @stack.pop
      end
    end
    
    def run(&block)
      measure = (1..runs).inject(Benchmark::Tms.new){|memo, i|
        memo + Benchmark.measure{ block.call(i) }
      } 
      output(@stack.last.merge(:runs => runs, :time => measure))
      measure
    end
    
  end
  
end # module Bench
require "bench/loader"
require "bench/aggregator"
require "bench/summarize"