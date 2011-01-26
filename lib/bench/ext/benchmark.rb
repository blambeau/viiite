module Benchmark
  class Tms
    
    def coerce(i)
      case i
      when 0
        [ self, Tms.new ]
      else 
        super
      end
    end
    
  end # class Tms
end # module Benchmark