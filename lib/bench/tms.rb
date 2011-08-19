module Bench
  class Tms

    FIELDS = [:utime, :stime, :cutime, :cstime, :real]

    def initialize(tms)
      @tms = tms
    end

    def self.coerce(arg)
      case arg
      when Bench::Tms
        arg
      when Benchmark::Tms
        Bench::Tms.new arg.to_a[1..-1]
      when Numeric
        Bench::Tms.new [arg, 0.0, 0.0, 0.0, 0.0]
      when Hash
        Bench::Tms.new FIELDS.collect{|f| arg[f] || 0.0}
      when Array
        Bench::Tms.new arg
      else
        raise ArgumentError, "Invalid value #{arg.inspect} for Bench::Tms"
      end
    end

    def utime;  @tms[0];  end
    def stime;  @tms[1];  end
    def cutime; @tms[2]; end
    def cstime; @tms[3]; end
    def real;   @tms[4];   end
    def total;  cutime + cstime + stime + utime; end

    def to_ruby_literal
      "Bench::Tms(#{to_a.collect{|f| f.inspect}.join(',')})"
    end

    def to_h
      @to_h ||= Hash[FIELDS.collect{|f| [f, send(f)]}]
    end

    def to_a
      @to_a ||= FIELDS.collect{|f| send(f)}
    end

    def hash
      to_a.hash
    end

    def ==(other)
      other.is_a?(Tms) && (other.to_a == self.to_a)
    end
    alias :eql? :==

  end # class Tms
end # module Bench
