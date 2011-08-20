require "viiite/version"
require "viiite/loader"
require "viiite/tms"
require "viiite/formatter"
require "viiite/runner"
require "viiite/command"
require "viiite/viiite_file"
require "benchmark"

#
# Benchmarking and complexity analyzer utility
#
module Viiite

  # Builds a Tms object
  def self.Tms(*args)
    Viiite::Tms.coerce(args)
  end

  def self.measure(&block)
    Viiite::Tms.coerce Benchmark.measure(&block)
  end

  # Builds a runner instance via the DSL definition given by the block.
  #
  # Example
  #
  #  Viiite.runner do |b|
  #    b.variation_point :ruby_version, Viiite.which_ruby
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
  def self.bm(&block)
    Runner.new(block)
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

end # module Viiite
