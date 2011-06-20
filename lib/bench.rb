require "bench/version"
require "bench/loader"
require "benchmark"

#
# Benchmarking and complexity analyzer utility
#
module Bench

  #
  # Builds a runner instance via the DSL definition given by the block.
  #
  # Example
  #
  #  Bench.runner do |b|
  #    b.variation_point :ruby_version, Bench.short_ruby_descr
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
  # Returns a short string with a ruby interpreter description
  # 
  def self.short_ruby_descr
    if Object.const_defined?(:RUBY_DESCRIPTION)
      RUBY_DESCRIPTION =~ /^([^\s]+\s*[^\s]+)/
      $1
    else
      "ruby #{RUBY_VERSION} (#{RUBY_PLATFORM})"
    end
  end
    
end # module Bench
require "bench/runner"
require "bench/formatter/plot"
