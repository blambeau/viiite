module Viiite
  class NTimes
    include Unit

    def initialize(delegate, n, key)
      @delegate, @n, @key = delegate, n, key
    end
    
    def config
      delegate.config
    end
    
    def path
      delegate.path
    end
    
    protected
    
    def _run(extra, reporter)
      @n.times do |i|
        @delegate.run(extra.merge(@key => i), reporter)
      end
    end

  end # class NTimes
end # module Viiite