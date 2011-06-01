module Bench
  class Command
    # 
    # Run a benchmark 
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} BENCHFILE
    #
    class Run < Quickl::Command(__FILE__, __LINE__)
      
      options do |opt|
        
      end

      def execute(args)
        raise Quickl::InvalidArgument unless args.size == 1
        file = args.first
        res = Kernel.instance_eval(File.read(file), file)
        case res
          when Bench::BenchCase
            res.execute{|tuple| puts tuple.inspect}
          else
            raise Quickl::Error, "Unable to execute #{file}"
        end
      end

    end # class Help
  end # class Command
end # module Bench
