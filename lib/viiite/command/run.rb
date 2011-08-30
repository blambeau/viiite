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
          @run_key = val.to_sym
        end
      end

      def execute(argv)
        argv = requester.bdb.to_rel.collect{|t| t[:name]} if argv.empty?
        argv.each do |name|
          benchmark = single_source([name]) do |bdb, arg|
            bdb.benchmark(arg)
          end
          @runs.times do |run|
            benchmark.each do |tuple|
              tuple = tuple.merge(@run_key => run) if @run_key
              $stdout << Alf::Tools.to_ruby_literal(tuple) << "\n"
            end
          end
        end
      end

    end # class Run
  end # class Command
end # module Viiite
