module Bench
  class Command
    # 
    # Run a benchmark 
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} BENCHFILE
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Run < Quickl::Command(__FILE__, __LINE__)
      
      def execute(args)
        raise Quickl::InvalidArgument if args.size != 1
        arg = args.first
        bench = Kernel.instance_eval(File.read(arg), arg)
        bench.each do |tuple|
          puts tuple.inspect
        end
      end

    end # class Help
  end # class Command
end # module Bench
