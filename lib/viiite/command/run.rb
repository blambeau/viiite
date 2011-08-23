module Viiite
  class Command
    # 
    # Run a benchmark and output raw data
    #
    # SYNOPSIS
    #   viiite #{command_name} [BENCHFILE]
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Run < Quickl::Command(__FILE__, __LINE__)
      include Commons

      def execute(argv)
        input, output = single_source(argv), $stdout
        Alf::Renderer.rash(input).execute(output)
      end

    end # class Run
  end # class Command
end # module Viiite
