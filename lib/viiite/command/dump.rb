module Viiite
  class Command
    #
    # Dump a relation from the benchmark database
    #
    # SYNOPSIS
    #   viiite #{command_name} [RELATION]
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Dump < Quickl::Command(__FILE__, __LINE__)

      options do |opt|
        @renderer = :rash
        opt.on('-t','--text',
               'Outputs a human-readable table') do
          @renderer = :text
        end
      end

      def database
        Database.new requester.config
      end

      def dump(relation)
        r = Alf::Renderer.renderer(@renderer, relation)
        r.execute($stdout)
      end

      def execute(argv)
        raise Quickl::Help unless argv.size <= 1
        db = database
        case arg = argv.first
        when "benchmarks"
          dump db.benchmarks(Path('.').expand)
        when NilClass
          db.benchmarks.each do |tuple|
            dump db.benchmark_result(tuple)
          end
        else
          if rel = db.benchmark_result(arg) 
            dump rel
          else
            $stderr << "No such benchmark #{arg}\n"
            exit(1)
          end
        end
      end

    end # class Dump
  end # class Command
end # module Viiite
