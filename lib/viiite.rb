require "viiite/version"
require "viiite/loader"
require "viiite/errors"

#
# Benchmarking and complexity analyzer utility
#
module Viiite

  # Much missing boolean type
  Boolean = Myrrha::Boolean

  # Duplicate, reuse and extend Myrrha default coercions
  Coercions = Myrrha::Coerce.dup.append do |r|
    r.coercion(String, Path){|value, _| Path(value)}
  end    

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
    warn "Viiite.bm is deprecated, use Viiite.bench #{caller[0]}"
    bench(&block)
  end

  require 'viiite/facts/ruby_facts'
  extend(RubyFacts)

end # module Viiite
require "viiite/tms"
require 'viiite/configuration'
require "viiite/benchmark"
require "viiite/suite"
require "viiite/command"
require "viiite/bdb"

require 'viiite/reporter'