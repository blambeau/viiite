module Bench
  class BenchFile < Alf::Reader

    # (see Alf::Reader#each)
    def each
      op = if input.is_a?(String)
        Kernel.instance_eval(input_text, input)
      else
        Kernel.instance_eval(input_text)
      end
      op.each(&Proc.new)
    end
    
    Alf::Reader.register(:bench, [".bench"], self)
  end # class BenchFile
end # module Bench
