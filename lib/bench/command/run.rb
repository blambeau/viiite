module Bench
  class Command
    # 
    # Run a benchmark and output raw data
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [BENCHFILE]
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Run < Quickl::Command(__FILE__, __LINE__)
      
      def execute(args)
        raise Quickl::InvalidArgument if args.size > 1
        input  = Alf::Reader.reader(args.first || $stdin)
        output = $stdout
        Alf::Renderer.rash(input).execute(output)
      end

    end # class Run
  end # class Command
end # module Bench
