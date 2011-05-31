#
# Benchmarking and complexity analyzer utility
#
module Bench
  
  VERSION = "1.0.0".freeze

  def self.define(&block)
    BenchCase.new(block)
  end

  def self.short_ruby_descr
    if Object.const_defined?(:RUBY_DESCRIPTION)
      RUBY_DESCRIPTION =~ /^([^\s]+\s*[^\s]+)/
      $1
    else
      "ruby #{RUBY_VERSION} (#{RUBY_PLATFORM})"
    end
  end
  
  class BenchCase
    include Enumerable
    
    # Creates a benchmarking case instance
    def initialize(defn)
      @defn = defn
    end

    def with(hash)
      if block_given?
        @stack << @stack.last.merge(hash)
        res = yield
        @stack.pop
        res
      else
        @stack.last.merge!(hash)
      end  
    end
  
    def variation_point(name, value, &block)
      with(name => value, &block)
    end
    
    def report(&block)
      measure = Benchmark.measure{ block.call }
      with :stime => measure.stime,
           :utime => measure.utime,
           :total => measure.total,
           :real  => measure.real do
        output
      end
    end

    def execute(&reporter)
      @stack, @reporter = [ {} ], reporter
      self.instance_eval &@defn
      @stack, @reporter = nil, nil
    end
    alias :each :execute
    
    private    

    def output
      @reporter.call @stack.last.dup
    end

  end # class BenchCase
  
end # module Bench
require "bench/loader"
require "bench/aggregator"
require "bench/summarize"
