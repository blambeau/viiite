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

      options do |opt|
        @runs = 1
        opt.on("--runs=[NB]", 
               "Run the benchmark NB times") do |val|
          @runs = val.to_i
          @run_key = :run unless @run_key
        end
        @run_key = nil
        opt.on("--run-key=[KEY]", 
               "Specify the run key (default to :run)") do |val|
          @run_key = val
        end
      end

      def execute(argv)
        argv = requester.bdb.map{|t| t[:name]} if argv.empty?
        argv.each do |name|
          benchmark = single_source([name]) do |bdb, arg|
            bdb.benchmark(arg)
          end
          if @run_key
            generator = Alf.lispy.generator(@runs, @run_key)
            benchmark = Alf.lispy.join(benchmark, generator)
          end
          Alf::Renderer.rash(benchmark).execute($stdout)
        end
      end

    end # class Run
  end # class Command
end # module Viiite
