module Viiite
  class BDB
    class Cached < SimpleDelegator
      include Utils

      attr_reader :cache_folder

      def initialize(delegate, cache_folder)
        super delegate
        @cache_folder = Pathname.new(cache_folder)
      end

      def cached?
        true
      end

      def benchmark(name)
        bench = super(name)
        cache = cache_file(name)
        Proxy.new(bench, cache)
      end

      def dataset(name)
        if (cache_file = cache_file(name)).exist?
          Alf::Reader.reader(cache_file.to_s, self) # FIXME: Alf::Reader should accept a Pathname
        else
          benchmark(name)
        end
      end

      private

      def cache_file(name)
        bench_file(@cache_folder, name, ".rash")
      end

      class Proxy < DelegateClass(Benchmark)
        include Alf::Iterator

        def initialize(benchmark, cache_file)
          @benchmark  = benchmark
          @cache_file = cache_file
          super(@benchmark)
        end

        def each
          @cache_file.dirname.mkpath
          @cache_file.open('a') do |io|
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
