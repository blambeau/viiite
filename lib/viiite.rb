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
  #  Viiite.bench do |b|
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
  def self.bench(&block)
    Benchmark.new(block)
  end

  # Alias of Viiite.bench for compatibility
  def self.bm(&block)
    warn "Viiite.bm is deprecated, use Viiite.bench instead #{caller[0]}"
    bench(&block)
  end

  #
  # Returns a short string with a ruby interpreter description
  #
  def self.which_ruby
    if Object.const_defined?(:RUBY_DESCRIPTION)
      short_ruby_description(RUBY_DESCRIPTION)
    else
      "ruby #{RUBY_VERSION}"
    end
  end

  def self.short_ruby_description(description)
    case description
    when /Ruby Enterprise Edition (\d{4}\.\d{2})/
      "ree #{$1}"
    when /^(\w+ \d\.\d\.\d) .+ patchlevel (\d+)/
      "#{$1}p#{$2}"
    when /^\w+ \S+/
      $&
    else
      raise "Unknown ruby interpreter: #{description}"
    end
  end

end # module Viiite
