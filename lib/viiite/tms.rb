module Viiite
  class Tms < Struct.new(:utime, :stime, :cutime, :cstime, :real)

    FMTSTR = "%10.6u %10.6y %10.6t %10.6r"

    def initialize(utime, stime, cutime, cstime, real)
      super # ensure we have all 5 non-nil arguments
    end

    def self.coerce(arg)
      case arg
      when Viiite::Tms
        arg
      when Numeric
        Viiite::Tms.new arg, 0.0, 0.0, 0.0, 0.0
      when Hash
        Viiite::Tms.new(*members.collect{|f| arg[f] || 0.0})
      when Array
        Viiite::Tms.new(*arg)
      else
        raise ArgumentError, "Invalid value #{arg.inspect} for Viiite::Tms"
      end
    end

    def total
      cutime + cstime + stime + utime
    end

    def to_ruby_literal
      "Viiite::Tms(#{to_a.collect{|f| f.inspect}.join(',')})"
    end

    def *(x);     memberwise(:*, x)     end
    def +(other); memberwise(:+, other) end
    def -(other); memberwise(:-, other) end
    def /(other); memberwise(:/, other) end

    def coerce(other)
      [self, other]
    end

    def to_h
      @to_h ||= Hash[members.zip(values)]
    end

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
      when Viiite::Tms
        Viiite::Tms.new(*values.zip(x.values).collect {|a,b| a.__send__(op, b)})
      else
        Viiite::Tms.new(*values.collect{|v| v.__send__(op, x)})
      end
    end

    if RUBY_VERSION < '1.9'
      public
      def members; super.map(&:to_sym); end
      def self.members; super.map(&:to_sym); end
    end
  end # class Tms

  def self.Tms(*args)
    Viiite::Tms.new(*args)
  end
end # module Viiite
