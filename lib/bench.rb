require "bench/version"
require "bench/loader"
require "bench/tms"
require "bench/formatter"
require "bench/runner"
require "bench/command"
require "bench/bench_file"
require "benchmark"

#
# Benchmarking and complexity analyzer utility
#
module Bench

  # Builds a Tms object
  def self.Tms(*args)
    Bench::Tms.coerce(args)
  end

  def self.measure(&block)
    Bench::Tms.coerce Benchmark.measure(&block)
  end

  # Builds a runner instance via the DSL definition given by the block.
  #
  # Example
  #
  #  Bench.runner do |b|
  #    b.variation_point :ruby_version, Bench.which_ruby
  #    b.range_over([100, 1000, 10000, 100000], :runs) do |runs|
  #      b.variation_point :test, :via_reader do
  #        b.report{ runs.times{ foo.via_reader } }
  #      end
  #      b.variation_point :test, :via_method do
  #        b.report{ runs.times{ foo.via_method } }
  #      end
  #    end
  #  end
  # 
  def self.runner(&block)
    Runner.new(block)
  end

  #
  # Builds a runner instance and runs it
  #
  def self.run(&block)
    runner(&block).each do |tuple|
      puts Alf::Tools.to_ruby_literal(tuple)
    end
  end

  #
  # Returns a short string with a ruby interpreter description
  # 
  def self.which_ruby
    if Object.const_defined?(:RUBY_DESCRIPTION)
      RUBY_DESCRIPTION =~ /^([^\s]+\s*[^\s]+)/
      $1
    else
      "ruby #{RUBY_VERSION} (#{RUBY_PLATFORM})"
    end
  end

end # module Bench
