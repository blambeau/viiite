module Viiite
  class BDB
    class Immediate
      include Utils
      include Alf::Iterator

      attr_reader :folder

      def initialize(folder, pattern = DEFAULT_OPTIONS[:pattern])
        @folder = folder
        if pattern =~ /(\.\w+)$/
          @pattern = pattern
          @ext = $1
        else
          raise InvalidPattern, "The benchmark suite pattern must end with a unique extension " <<
                                "(for deducing benchmark file from name): #{pattern}"
        end
      end

      def each
        Dir[File.join(folder, @pattern)].each do |f|
          yield(:name => f[1+folder.size..-1-@ext.size], :file => f)
        end
      end

      def cached?
        false
      end

      def benchmark(name)
        if File.exists?(file = bench_file(folder, name.to_s, @ext))
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
