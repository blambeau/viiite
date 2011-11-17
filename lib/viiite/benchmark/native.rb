module Viiite
  class Benchmark
    module Native

      TIME_PARSERS = [
        # elapsed-time parser
        [ :elapsed,
          /\A(\d+\.\d+)\Z/, 
          lambda{|m| 
            Tms.coerce(Float(m[1]))
          }],
        # POSIX 1003.2
        [ :posix,
          /\Areal (\d+\.\d+)\nuser (\d+\.\d+)\nsys (\d+\.\d+)\Z/, 
          lambda{|m|
            Tms.new(Float(m[2]), Float(m[3]), 0.0, 0.0, Float(m[1]))
          }],
        # ZSH's time command
        [ :zshtime,
          /\A.*? (\d+\.\d+)s user (\d+\.\d+)s system .*? (\d+\.\d+) total\Z/,
          lambda{|m| 
            Tms.new(Float(m[1]), Float(m[2]), 0.0, 0.0, Float(m[3]))
          } ]
      ]

      def self.time_parser(which)
        lambda{|io|
          p = TIME_PARSERS.find{|p| p.first == which}
          tms = p[2].call(p[1].match(io.read.strip))
          {:tms => tms}
        }
      end

      def report_native(*args, &block)
        args << {} unless Hash === args.last
        parser = block || Native.time_parser(:elapsed)

        # Execute native command and parse result so as to get
        # a relation (sfl provides Kernel.spawn for 1.8.x)
        require "sfl" if RUBY_VERSION < "1.9"
        r, w  = IO.pipe
        args.last.merge!(:out => w)
        Process.wait Kernel.spawn(*args)
        w.close

        result = parser.call(r)
        result = [result] if result.is_a?(Hash)
        result = Alf::Relation.coerce(result)

        # Enclose in a new relation
        tuple = @tuple.dup.merge(:native_result => result)
        rel   = Alf::Relation.coerce([tuple])

        # Yield flattened tuples
        rel.ungroup(:native_result).each do |tuple|
          @reporter.call(tuple)
        end
      end

    end # module Native
  end # class Benchmark
end # module Viiite
