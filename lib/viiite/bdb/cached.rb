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

      def dataset(name)
        cached_file = bench_file(cache_folder, name, ".rash")
        unless File.exists?(cached_file)
          reader = delegate.dataset(name)
          mkdir_p(File.dirname(cached_file))
          File.open(cached_file, "w") do |io|
            Alf::Renderer.rash(reader).execute(io)
          end
        end
        Alf::Reader.reader(cached_file, self)
      end

      private 
      
      def mkdir_p(folder)
        require 'fileutils'
        FileUtils.mkdir_p(folder)
      end

    end # class Cached
  end # class BDB
end # module Viiite
