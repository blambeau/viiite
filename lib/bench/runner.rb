module Bench
  class Runner
    include Alf::Iterator

    def initialize(defn)
      @defn = defn
    end

    ### DSL
    
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
  
    def variation_point(name, value, &proc)
      h = {name => value}
      with(h, &proc)
    end
    
    def report(hash = {}, &block)
      hash = {:bench => hash} unless hash.is_a?(Hash)
      with(hash) {
        with(:tms => Bench.measure{block.call}){ output }
      }
    end

    ### Alf contract
    
    def each(&reporter)
      self.dup._each(&reporter)
    end
    
    protected    

    def _each(&reporter)
      @stack, @reporter = [ {} ], reporter
      self.instance_eval &@defn
      @stack, @reporter = nil, nil
    end
    
    def output
      @reporter.call @stack.last.dup
    end

  end # class Runner
end # module Bench
