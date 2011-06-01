#!/usr/bin/env bench
require File.expand_path("../sort", __FILE__)

# Benchmark definition, use 'bench run ...' to run it
Bench.runner do |b|
  b.variation_point :ruby_version, Bench.short_ruby_descr
  b.range_over([1, 50, 100, 150, 200, 250, 300], :size) do |size|
    1.times do 
      array = Array.new(size){ Kernel.rand }
      b.variation_point :test, :quicksort do
        b.report{ quicksort(array) }
      end
      b.variation_point :test, :bubblesort do
        b.report{ bubblesort(array) }
      end
    end
  end
end

