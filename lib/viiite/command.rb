module Viiite
  #
  # viiite - Benchmark ruby scripts the easy way
  #
  # SYNOPSIS
  #   viiite [--version] [--help] COMMAND [cmd opts] ARGS...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # COMMANDS
  # #{summarized_subcommands}
  #
  # DESCRIPTION
  #   This command helps you benchmarking ruby applications and manipulating
  #   benchmark results very simply.
  #
  # See 'viiite help COMMAND' for more information on a specific command.
  #
  class Command < Quickl::Delegator(__FILE__, __LINE__)

    # Install options
    options do |opt|
      opt.on("-Idirectory", 
             "specify $LOAD_PATH directory (may be used more than once)") do |val|
        $LOAD_PATH.unshift val
      end
      opt.on('-rlibrary',
             "require the library, before executing viiite") do |lib|
        require(lib)
      end
      @db_folder = "benchmarks"
      opt.on('--db=FOLDER', 
             "Specify the benchmark folder (defaults to 'benchmarks')") do |val|
        unless File.directory?(val)
          raise Quickl::InvalidArgument, "Missing folder #{val}"
        end
        @db_folder = val
      end
      opt.on_tail("--help", "Show help") do
        raise Quickl::Help
      end
      opt.on_tail("--version", "Show version") do
        raise Quickl::Exit, "viiite #{Viiite::VERSION} (c) 2011, Bernard Lambeau"
      end
    end

    def bdb
      @bdb ||= BDB.immediate(@db_folder)
    end
    
  end # class Command
end # module Viiite
require "viiite/command/commons"
require "viiite/command/help"
require "viiite/command/run"
require "viiite/command/report"
require "viiite/command/plot"
