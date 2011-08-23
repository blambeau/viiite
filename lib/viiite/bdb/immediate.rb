module Viiite
  class BDB
    class Immediate < BDB
      include Utils

      def initialize(folder)
        @folder = folder
      end

      def dataset(name)
        if File.exists?(name.to_s)
          return Alf::Reader.reader(name, self)
        elsif File.exists?(file = bench_file(folder, name, ".rb"))
          return Alf::Reader.reader(file, self)
        else
          raise Alf::NoSuchDatasetError, "No such benchmark #{name}"
        end
      end

    end # class Immediate
  end # class BDB
end # module Viiite
