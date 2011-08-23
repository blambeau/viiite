module Viiite
  class BDB
    module Utils

      def rextname(file, ext)
        extname = File.extname(file.to_s)
        if extname.empty? 
          "#{file.to_s}#{ext}"
        else
          "#{file.to_s[0..-(1+extname.size)]}#{ext}"
        end
      end

    end # module Utils
  end # class BDB
end # module Viiite