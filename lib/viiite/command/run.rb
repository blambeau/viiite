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
      
      def run_one(unit)
        unit = NTimes.new(unit, @runs, @run_key) if @run_key
        unit.run do |tuple|
          puts Alf::Tools::ToRubyLiteral.apply(tuple)
        end
      end
      
      def execute_files(files)
        files.each do |f|
          run_one Viiite.bench(f)
        end
      end
      
      def execute_names(names)
        which = Alf::Relation.coerce(names.map{|n| {:name => n}})
        database.suite.join(which).each do |t|
          run_one t[:suite]
        end
      end
      
      def execute(argv)
        if argv.empty?
          files, names = [], ['.']
        else
          files, names = argv.partition{|f| Path(f).file?}
        end
        execute_files(files)
        execute_names(names)
      end

    end # class Run
  end # class Command
end # module Viiite
