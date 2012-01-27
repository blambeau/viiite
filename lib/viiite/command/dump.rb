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
      include Commons

      options do |opt|
        @renderer = :rash
        opt.on('-t','--text',
               'Outputs a human-readable table') do
          @renderer = :text
        end
      end

      def dump(relation)
        r = Alf::Renderer.renderer(@renderer, relation)
        r.execute($stdout)
      end

      def execute(argv)
        if argv.empty?
          @renderer = :text
          dump database.suite
        else
        end
      end

    end # class Dump
  end # class Command
end # module Viiite
