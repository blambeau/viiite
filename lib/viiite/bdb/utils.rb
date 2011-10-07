module Viiite
  class BDB
    module Utils

      def bench_file(folder, name, ext)
        folder.join(name).replace_extension(ext)
      end

    end # module Utils
  end # class BDB
end # module Viiite
