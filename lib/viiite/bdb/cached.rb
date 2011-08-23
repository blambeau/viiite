module Viiite
  class BDB
    class Cached
      include Utils

      attr_reader :delegate
      attr_reader :cache_folder
      attr_reader :cache_mode

      def initialize(delegate, cache_folder, cache_mode = "w")
        @delegate     = delegate
        @cache_folder = cache_folder
        @cache_mode   = cache_mode
      end

      def cached?
        true
      end

      def folder
        delegate.folder
      end

      def benchmark(name)
        bm    = delegate.benchmark(name)
        cache = cache_file(name)
        Proxy.new(bm, cache, cache_mode)
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

        def initialize(benchmark, cache_file, cache_mode)
          @benchmark  = benchmark
          @cache_file = cache_file
          @cache_mode = cache_mode
          super(@benchmark)
        end

        def each
          FileUtils.mkdir_p(File.dirname(@cache_file))
          File.open(@cache_file, @cache_mode) do |io|
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
