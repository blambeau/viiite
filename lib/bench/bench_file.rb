def bench_clean_binding
  binding
end

module Bench
  class BenchFile < Alf::Reader

    # (see Alf::Reader#each)
    def each
      op = if input.is_a?(String)
        Kernel.eval(input_text, bench_clean_binding, input)
      else
        Kernel.eval(input_text, bench_clean_binding)
      end
      op.each(&Proc.new)
    end
    
    Alf::Reader.register(:bench, [".bench", ".rb"], self)
  end # class BenchFile
end # module Bench
