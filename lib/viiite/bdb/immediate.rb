module Viiite
  class BDB
    class Immediate
      include Utils
      include Alf::Iterator

      attr_reader :folder

      def initialize(folder, options = DEFAULT_OPTIONS)
        @folder = folder
        @pattern = options[:pattern]
        @ext = options[:ext]
      end

      def each
        Dir[File.join(folder, "**/#{@pattern}")].each do |f|
          yield({
            :name  => f[(1+folder.size)..-(1+@ext.size)],
            :file  => f,
          })
        end
      end

      def cached?
        false
      end

      def benchmark(name)
        if File.exists?(file = bench_file(folder, name, @ext))
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
