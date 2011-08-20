module Bench
  #
  # bench - Benchmark ruby scripts the easy way
  #
  # SYNOPSIS
  #   #{program_name} [--version] [--help] COMMAND [cmd opts] ARGS...
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
  # See '#{program_name} help COMMAND' for more information on a specific command.
  #
  class Command < Quickl::Delegator(__FILE__, __LINE__)

    # Install options
    options do |opt|
      opt.on("-Idirectory", 
             "specify $LOAD_PATH directory (may be used more than once)") do |val|
        $LOAD_PATH.unshift val
      end
      opt.on('-rlibrary',
             "require the library, before executing bench") do |lib|
        require(lib)
      end
      opt.on_tail("--help", "Show help") do
        raise Quickl::Help
      end
      opt.on_tail("--version", "Show version") do
        raise Quickl::Exit, "#{program_name} #{Bench::VERSION} (c) 2011, Bernard Lambeau"
      end
    end
    
  end # class Command
end # module Bench
require "bench/command/help"
require "bench/command/run"
require "bench/command/report"
require "bench/command/plot"
