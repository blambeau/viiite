---
layout: default
title: Viiite &mdash; An alternative to Benchmark
---
# Viiite &mdash; An alternative to Benchmark

After a first sketch a few weeks ago, I've decided to dedicate my *whyday* on Viiite. Viiite is an alternative to Benchmark, designed to let benchmarks evolve smootlhy from simple measures to complete benchmarking infrastructures. It does it through a separation of concerns between *running* benchmarks (viiite run) and *reporting* benchmarking results (viiite report). 

## Starting 'ala' Benchmark

Let's starts with the common Benchmark example, performing very simple measures first. In Viiite, this goes as follows:

    # bench_iteration.rb
    n = 15000
    Viiite.bm do |r|
      r.report(:for)   { for i in 1..n; a = "1"; end }
      r.report(:times) { n.times do   ; a = "1"; end }
      r.report(:upto)  { 1.upto(n) do ; a = "1"; end }
    end

In such a simple case, the reporting command provides a one-liner for 'run + report with default options':

    $ viiite report bench_iteration.rb
    +--------+-----------------------------------------------+
    | :bench | :measure                                      |
    +--------+-----------------------------------------------+
    | :for   |   0.000000   0.000000   0.000000 (  0.007995) |
    | :times |   0.010000   0.000000   0.010000 (  0.006995) |
    | :upto  |   0.010000   0.000000   0.010000 (  0.007034) |
    +--------+-----------------------------------------------+

## Going far further...

Why not comparing sort methods on different rubies? Here is the benchmark:

    # bench_sort.rb
    require 'viiite'
    class Array
      def random(x) 
        # ...
      end
      def quicksort
        # ...
      end
      def bubblesort
        # ...
      end
    end
    
    Viiite.bm do |b|
      b.variation_point :ruby, Viiite.which_ruby
      b.range_over([100, 200, 300, 400, 500], :size) do |size|
        b.range_over(1..5, :i) do
          viiite_case = Array.random(size)
          b.report(:quicksort) { viiite_case.quicksort }
          b.report(:bubblesort){ viiite_case.bubblesort }
        end
      end
    end

And here is a way to obain a comparison of ruby versions/implementations:

    $ rvm exec viiite run bench_sort.rb | \
      viiite plot -x size -y tms.total --series=ruby --graph=bench --gnuplot

![Comparing Bubblesort complexity with Viiite](/images/bubblesort-rubies.jpeg)

You'll find typical use-cases in the menu at left!
