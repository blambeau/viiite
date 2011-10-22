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
        @folder.glob(@pattern).each do |f|
          yield(:name => f.relative_to(@folder).without_extension.to_s, :file => f)
        end
      end

      def cached?
        false
      end

      def benchmark(name)
        if (file = bench_file(@folder, name.to_s, @ext)).exist?
          return Alf::Reader.reader(file.to_s, self) # FIXME
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
