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
end # module Bench
