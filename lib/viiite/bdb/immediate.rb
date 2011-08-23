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
        elsif file = find_benchmark_file(name)
          return Alf::Reader.reader(file, self)
        else
          raise Alf::NoSuchDatasetError, "No such benchmark #{name}"
        end
      end

      private 

      def find_benchmark_file(name)
        return name if File.exists?(name.to_s)
        bench_file = rextname(name, ".rb")
        bench_file = File.join(folder, bench_file)
        File.exists?(bench_file) ? bench_file : nil
      end

    end # class Immediate
  end # class BDB
end # module Viiite
