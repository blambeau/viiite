module Viiite
  class BDB
    class Cached
      include Utils

      attr_reader :delegate
      attr_reader :cache_folder
      attr_reader :mode

      def initialize(delegate, cache_folder, mode = "w")
        @delegate     = delegate
        @cache_folder = cache_folder
        @mode         = mode
      end

      def benchmark(name)
        bm    = delegate.benchmark(name)
        cache = cache_file(name)
        Proxy.new(bm, cache, mode)
      end

      def dataset(name)
        if File.exists?(cache_file = cache_file(name))
          Alf::Reader.reader(cache_file, self)
        else
          benchmark(name)
        end
      end

      private

      def cache_file(name)
        bench_file(cache_folder, name, ".rash")
      end
      
      class Proxy < DelegateClass(Benchmark)
        include Alf::Iterator

        def initialize(benchmark, cache_file, mode)
          @benchmark  = benchmark
          @cache_file = cache_file
          @mode       = mode
          super(@benchmark)
        end

        def each
          FileUtils.mkdir_p(File.dirname(@cache_file))
          File.open(@cache_file, @mode) do |io|
            @benchmark.each do |tuple|
              io << Alf::Tools.to_ruby_literal(tuple) << "\n"
              yield(tuple)
            end
          end
        end

      end # class Proxy

    end # class Cached
  end # class BDB
end # module Viiite
