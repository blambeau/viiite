require 'fileutils'
require "delegate"

require "viiite/version"
require "viiite/loader"
require "viiite/errors"
require "viiite/tms"
require "viiite/benchmark"
require "viiite/command"
require "viiite/bdb"

#
# Benchmarking and complexity analyzer utility
#
module Viiite

  def self.measure
    t0, r0 = Process.times, Time.now
    yield
    t1, r1 = Process.times, Time.now
    Tms.new(t1.utime  - t0.utime,
            t1.stime  - t0.stime,
            t1.cutime - t0.cutime,
            t1.cstime - t0.cstime,
            r1 - r0)
  end

  # Builds a runner instance via the DSL definition given by the block.
  #
  # Example
  #
  #  Viiite.bm do |b|
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
    Benchmark.new(block)
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
