module Viiite
  class BDB
    class Immediate < BDB
      include Utils

      attr_reader :folder

      def initialize(folder)
        @folder = folder
      end

      def dataset(name)
        if File.exists?(file = bench_file(folder, name, ".rb"))
          return Alf::Reader.reader(file, self)
        elsif File.exists?(file = bench_file(folder, name, ".rash"))
          return Alf::Reader.reader(file, self)
        else
          raise Alf::NoSuchDatasetError, "No such benchmark #{name}"
        end
      end

    end # class Immediate
  end # class BDB
end # module Viiite
