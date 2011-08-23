require 'viiite/benchmark/runner'
module Viiite
  class Benchmark
    include Runner
    include Alf::Iterator

    attr_reader :definition

    def initialize(definition)
      @definition = definition
    end

    def self.new(arg)
      case arg
      when String
        Kernel.eval(File.read(arg), viiite_clean_binding, arg)
      when IO, StringIO
        Kernel.eval(arg.readlines.join, viiite_clean_binding)
      else
        super(arg)
      end
    end
    
    def each(&reporter)
      self.dup._each(&reporter)
    end

    Alf::Reader.register(:viiite, [".viiite", ".rb"], self)
  end # class Benchmark
end # module Viiite

def viiite_clean_binding
  binding
end

