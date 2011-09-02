module Viiite
  class BDB
    module Utils

      def replace_extension(file, ext)
        old_ext = File.extname(file)
        "#{file[0..-(1+old_ext.size)]}#{ext}"
      end

      def bench_file(folder, name, ext)
        File.join(folder, replace_extension(name, ext))
      end

    end # module Utils
  end # class BDB
end # module Viiite
