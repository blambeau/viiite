def viiite_clean_binding
  binding
end

module Viiite
  class ViiiteFile < Alf::Reader

    # (see Alf::Reader#each)
    def each
      op = if input.is_a?(String)
        Kernel.eval(input_text, viiite_clean_binding, input)
      else
        Kernel.eval(input_text, viiite_clean_binding)
      end
      op.each(&Proc.new)
    end
    
    Alf::Reader.register(:viiite, [".viiite", ".rb"], self)
  end # class ViiiteFile
end # module Viiite
