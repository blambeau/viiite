module Bench
  class Tms

    FMTSTR = "%10.6u %10.6y %10.6t %10.6r"
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

    def utime;  @tms[0]; end
    def stime;  @tms[1]; end
    def cutime; @tms[2]; end
    def cstime; @tms[3]; end
    def real;   @tms[4]; end
    def total;  cutime + cstime + stime + utime; end

    def to_ruby_literal
      "Bench::Tms(#{to_a.collect{|f| f.inspect}.join(',')})"
    end

    def *(x);     memberwise(:*, x)     end
    def +(other); memberwise(:+, other) end
    def -(other); memberwise(:-, other) end
    def /(other); memberwise(:/, other) end

    def coerce(other)
      [self, other]
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

    def format(arg0 = nil, *args)
      fmtstr = (arg0 || FMTSTR).dup
      fmtstr.gsub!(/(%[-+\.\d]*)u/){"#{$1}f" % utime}
      fmtstr.gsub!(/(%[-+\.\d]*)y/){"#{$1}f" % stime}
      fmtstr.gsub!(/(%[-+\.\d]*)U/){"#{$1}f" % cutime}
      fmtstr.gsub!(/(%[-+\.\d]*)Y/){"#{$1}f" % cstime}
      fmtstr.gsub!(/(%[-+\.\d]*)t/){"#{$1}f" % total}
      fmtstr.gsub!(/(%[-+\.\d]*)r/){"(#{$1}f)" % real}
      arg0 ? Kernel::format(fmtstr, *args) : fmtstr
    end
    alias :to_s :format

    private

    def memberwise(op, x)
      case x
      when Bench::Tms
        Bench::Tms.new FIELDS.collect{|f| __send__(f).__send__(op, x.send(f))}
      else
        Bench::Tms.new FIELDS.collect{|f| __send__(f).__send__(op, x)}
      end
    end

  end # class Tms
end # module Bench
