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

    attr_reader :config
    
    def initialize
      @config = Configuration.new
    end

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

      opt.on('--suite=FOLDER',
             "Specify the folder of the benchmark suite (defaults to 'benchmarks')") do |val|
        raise Quickl::InvalidArgument, "Missing folder #{val}" unless File.directory?(val)
        @config.benchmark_folder = val
      end
      opt.on('--pattern=GLOB',
             "Specify the pattern to find benchmarks in the suite folder (defaults to '**/*.rb')") do |glob|
        @config.benchmark_pattern = glob
      end
      opt.on('--cache=FOLDER',
             'Specify the cache folder') do |folder|
        @config.cache_folder = folder
      end
      opt.on('--no-cache',
             'Disable the cache') do
        @config.cache_folder = nil
      end

      opt.on_tail("--help", "Show help") do
        raise Quickl::Help
      end
      opt.on_tail("--version", "Show version") do
        raise Quickl::Exit, "viiite #{Viiite::VERSION} (c) 2011, Bernard Lambeau"
      end
    end

    def bdb
      @bdb ||= BDB.new(@config)
    end

  end # class Command
end # module Viiite
require "viiite/command/commons"
require "viiite/command/help"
require "viiite/command/dump"
require "viiite/command/run"
require "viiite/command/report"
require "viiite/command/compare"
require "viiite/command/plot"
