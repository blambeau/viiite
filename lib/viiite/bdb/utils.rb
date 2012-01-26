module Viiite
  class BDB
    module Utils

      def bench_file(folder, name, ext)
        folder.join(name).replace_extension(ext)
      end

      def folder
        config.benchmark_folder
      end

      def cache_folder
        config.cache_folder
      end

    end # module Utils
  end # class BDB
end # module Viiite
