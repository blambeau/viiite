module Viiite
  class BDB
    class Cached
      include Utils

      attr_reader :immediate

      def initialize(immediate)
        @immediate = immediate
      end

      # delegates to @immediate
      def method_missing(meth, *args, &block)
        super unless immediate.respond_to? meth
        immediate.send(meth, *args, &block)
      end

      def cached?
        true
      end

      def benchmark(name)
        bench = immediate.benchmark(name)
        cache = cache_file(name)
        Proxy.new(bench, cache)
      end

      def dataset(name)
        if (cache_file = cache_file(name)).exist?
          Alf::Reader.reader(cache_file, self)
        else
          benchmark(name)
        end
      end

      private

      def cache_file(name)
        bench_file(cache_folder, name, ".rash")
      end

      class Proxy
        include Alf::Iterator

        def initialize(benchmark, cache_file)
          @benchmark  = benchmark
          @cache_file = cache_file
        end

        def each
          @cache_file.dir.mkdir_p
          @cache_file.open('a') do |io|
            @benchmark.runner.each do |tuple|
              io << Alf::Tools.to_ruby_literal(tuple) << "\n"
              yield(tuple)
            end
          end
        end

      end # class Proxy

    end # class Cached
  end # class BDB
end # module Viiite
