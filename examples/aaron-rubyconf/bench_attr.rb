require File.expand_path("../foo", __FILE__)

# This is the class under benchmark
foo = Foo.new

# Benchmark definition, use 'bench run ...' to run it
Bench.define do |b|
  b.variation_point :ruby_version, Bench.short_ruby_descr
  b.range_over([100, 1000, 10000], :runs) do |runs|
    b.variation_point :test, :via_reader do
      b.report{ runs.times{ foo.via_reader } }
    end
    b.variation_point :test, :via_method do
      b.report{ runs.times{ foo.via_method } }
    end
  end
end

