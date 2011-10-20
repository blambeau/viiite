module Viiite
  class Benchmark
    module Runner

      def with(hash)
        if block_given?
          org_tuple = @tuple
          @tuple = org_tuple.merge(hash)
          res = yield
          @tuple = org_tuple
          res
        else
          @tuple.merge!(hash)
        end
      end

      def range_over(range, name = nil, &block)
        name ||= block.parameters.first.last if RUBY_VERSION > '1.9'
        raise ArgumentError, "You must specify a name (explicitely in 1.8)" unless name
        range.each do |value|
          with(name => value) { yield value }
        end
      end

      def variation_point(name, value, &proc)
        with({name => value}, &proc)
      end

      def report(hash = {}, &block)
        hash = {:bench => hash.to_sym} unless hash.is_a?(Hash)
        with(hash) {
          GC.start
          tms = Viiite.measure(&block)
          with(:tms => tms){ output }
        }
      end

      def report_native(env, command = nil, parser = nil, &block)
        # Argument conventions
        env, command, parser = nil, env, command unless env.is_a?(Hash)
        parser ||= (block || lambda{|io|
          {:tms => Tms.coerce(io.read.to_f) }
        })

        # Execute native command and parse result so as to get
        # a relation
        args = env.nil? ? command : [env, command]
        result = IO.popen(args, &parser)
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

      protected

      def _each(&reporter)
        @tuple, @reporter = {}, reporter
        if definition.arity <= 0
          instance_exec(&definition)
        else
          definition.call(self)
        end
        @tuple, @reporter = nil, nil
      end

      def output
        @reporter.call @tuple.dup
      end

    end # module Runner
  end # class Benchmark
end # module Viiite
