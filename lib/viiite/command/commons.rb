module Viiite
  class Command
    module Commons

      def single_source(argv)
        raise Quickl::InvalidArgument if argv.size > 1
        if arg = argv.first
          path = Path(arg.to_s)
          if path.file?
            if path.extname == ".rb"
              Benchmark.new(arg.to_s).runner
            else
              Alf::Reader.reader(path)
            end
          elsif requester && requester.respond_to?(:bdb)
            block_given? ? yield(requester.bdb, arg) : requester.bdb.dataset(arg)
          else
            raise Quickl::InvalidArgument, "Missing benchmark #{arg}"
          end
        else
          Alf::Reader.reader($stdin)
        end
      end

    end # module Commons
  end # class Command
end # module Viiite
