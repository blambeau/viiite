module Viiite
  class Benchmark
    module Native

      ELAPSED_TIME_PARSER = lambda{|io|
        tms = Tms.coerce(Float(io.read))
        {:tms => tms}
      }

      POSIX_1003_2_PARSER = lambda{|io|
        s = io.read.strip
        s =~ /\Areal (.*)\nuser (.*)\nsys (.*)\Z/
        tms = Tms.new(Float($2), Float($3), 0.0, 0.0, Float($1))
        {:tms => tms}
      }

      def report_native(*args, &block)
        args << {} unless Hash === args.last
        parser = block || ELAPSED_TIME_PARSER

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
