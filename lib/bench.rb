require "bench/version"
require "bench/loader"
require "benchmark"

#
# Benchmarking and complexity analyzer utility
#
module Bench

  class Runner
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
           :cstime => measure.cstime,
           :cutime => measure.cutime,
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
    
    def pipe(n)
      self
    end

    private    

    def output
      @reporter.call @stack.last.dup
    end

  end # class Runner

  #
  # Builds a runner instance via the DSL definition given by the block.
  #
  # Example
  #
  #  Bench.runner do |b|
  #    b.variation_point :ruby_version, Bench.short_ruby_descr
  #    b.range_over([100, 1000, 10000, 100000], :runs) do |runs|
  #      b.variation_point :test, :via_reader do
  #        b.report{ runs.times{ foo.via_reader } }
  #      end
  #      b.variation_point :test, :via_method do
  #        b.report{ runs.times{ foo.via_method } }
  #      end
  #    end
  #  end
  # 
  def self.runner(&block)
    Runner.new(block)
  end

  #
  # Returns a short string with a ruby interpreter description
  # 
  def self.short_ruby_descr
    if Object.const_defined?(:RUBY_DESCRIPTION)
      RUBY_DESCRIPTION =~ /^([^\s]+\s*[^\s]+)/
      $1
    else
      "ruby #{RUBY_VERSION} (#{RUBY_PLATFORM})"
    end
  end
    
end # module Bench
require "bench/formatter/plot"
