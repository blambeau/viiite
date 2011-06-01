require "bench/version"
require "bench/loader"
require "benchmark"
#
# Benchmarking and complexity analyzer utility
#
module Bench

  def self.define(&block)
    BenchCase.new(block)
  end

  def self.sortkeys(keys)
    keys.sort{|k1,k2|
      k1.respond_to?(:<=>) ? k1 <=> k2 : k1.to_s <=> k2.to_s
    }
  end

  def self.render(rel)
    Formatter::Text.render(rel)
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

    def range_over(range, name, &block)
      range.each do |value|
        with(name => value){ block.call(value) }
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
require "bench/aggregator"
require "bench/summarizer"
require "bench/formatter/text"
