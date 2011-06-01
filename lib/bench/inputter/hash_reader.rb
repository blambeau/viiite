module Bench
  class Inputter
    include Enumerable
    class HashReader < Inputter

      def initialize(input)
        @input = input
      end

      def each
        @input.each_line do |line|
          begin
            h = Kernel.eval(line)
            yield(h)
            raise "hash expected, got #{h}" unless h.is_a?(Hash) 
          rescue Exception => ex
            $stderr << "Skipping #{line}: #{ex.message}"
          end
        end
      end

    end # class HashReader
  end # class Inputter
end # module Bench
