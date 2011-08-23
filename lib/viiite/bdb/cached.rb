module Viiite
  class BDB
    class Cached < BDB
      include Utils

      attr_reader :delegate
      attr_reader :cache_folder

      def initialize(delegate, cache_folder)
        @delegate     = delegate
        @cache_folder = cache_folder
      end

      def benchmark(name)
        delegate.benchmark(name)
      end

      def dataset(name)
        cache_file = cache_file(name)
        run_one!(name, "w") unless File.exists?(cache_file)
        Alf::Reader.reader(cache_file, self)
      end

      private

      def run_one!(name, mode)
        cache_file = cache_file(name)
        mkdir_p(File.dirname(cache_file))
        reader = delegate.dataset(name)
        File.open(cache_file(name), mode) do |io|
          Alf::Renderer.rash(reader).execute(io)
        end
      end

      def cache_file(name)
        bench_file(cache_folder, name, ".rash")
      end
      
      def mkdir_p(folder)
        require 'fileutils'
        FileUtils.mkdir_p(folder)
      end

    end # class Cached
  end # class BDB
end # module Viiite
