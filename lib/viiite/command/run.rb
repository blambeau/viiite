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
        argv = requester.bdb.map{|t| t[:name]} if argv.empty?
        argv.each do |name|
          $stderr << "Running #{name}" << "\n"
          input = single_source([name]) do |bdb, arg|
            bdb.benchmark(arg)
          end
          Alf::Renderer.rash(input).execute($stdout)
        end
      end

    end # class Run
  end # class Command
end # module Viiite
