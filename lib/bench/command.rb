require "bench"
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
module Bench
  class Command < Quickl::Delegator(__FILE__, __LINE__)

    # Install options
    options do |opt|
      
      # Show the help and exit
      opt.on_tail("--help", "Show help") do
        raise Quickl::Help
      end

      # Show version and exit
      opt.on_tail("--version", "Show version") do
        raise Quickl::Exit, "#{program_name} #{Bench::VERSION} (c) 2011, Bernard Lambeau"
      end

    end

  end # class Delegator
end # module Bench
require "bench/command/run"
require "bench/command/plot"
require "bench/command/help"

