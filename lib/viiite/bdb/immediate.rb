module Viiite
  class BDB
    class Immediate
      include Utils
      include Alf::Iterator

      attr_reader :config

      def initialize(config)
        @config = config
        if config.benchmark_pattern =~ /(\.\w+)$/
          @ext = $1
        else
          raise InvalidPattern, "The benchmark suite pattern must end with a unique extension " <<
                                "(for deducing benchmark file from name): #{config.benchmark_pattern}"
        end
      end

      def each
        folder = config.benchmark_folder
        folder.glob(config.benchmark_pattern).each do |f|
          yield(:name => f.relative_to(folder).rm_ext.to_s, :file => f)
        end
      end

      def cached?
        false
      end

      def benchmark(name)
        if (file = bench_file(config.benchmark_folder, name, @ext)).exist?
          return Viiite.bench(file)
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
