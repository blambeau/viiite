module Viiite
  class BDB
    module Utils

      def rextname(file, ext)
        extname = File.extname(file.to_s)
        if extname.empty?
          "#{file}#{ext}"
        else
          "#{file.to_s[0..-(1+extname.size)]}#{ext}"
        end
      end

      def bench_file(folder, name, ext)
        File.join(folder, rextname(name, ext))
      end

    end # module Utils
  end # class BDB
end # module Viiite
