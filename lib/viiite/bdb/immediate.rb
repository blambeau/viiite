module Viiite
  class BDB
    class Immediate
      include Utils

      attr_reader :folder

      def initialize(folder)
        @folder = folder
      end

      def cached?
        false
      end

      def benchmark(name)
        if File.exists?(file = bench_file(folder, name, ".rb"))
          return Alf::Reader.reader(file, self)
        elsif File.exists?(file = bench_file(folder, name, ".rash"))
          return Alf::Reader.reader(file, self)
        else
          raise NoSuchBenchmarkError, "No such benchmark #{name}"
        end
      end

      def dataset(name)
        benchmark(name)
      rescue NoSuchBenchmarkError => ex
        raise Alf::NoSuchDatasetError, ex.message, ex.backtrace
      end

    end # class Immediate
  end # class BDB
end # module Viiite
