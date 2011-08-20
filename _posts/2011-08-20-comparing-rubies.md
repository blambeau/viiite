---
layout: default
title: Comparing rubies
---
# Comparing rubies with Bench

In this post, we show how to compare the performance of the same algorithm(s) under different ruby versions/implementations. We do it on the common bench_iteration benchmark.

First, we add a so-called *variation-point* to the benchmarking case, here under the `:ruby` key:

    require 'bench'
    n = 15000
    Bench.bm do |r|
      r.variation_point :ruby, Bench.which_ruby
      r.report(:for)   { for i in 1..n; a = "1"; end }
      r.report(:times) { n.times do   ; a = "1"; end }
      r.report(:upto)  { 1.upto(n) do ; a = "1"; end }
    end

## Running the benchmark thanks to RVM 

Running the benchmark may be done with 'bench run':

    $ bench run bench_iteration.rb
    {:ruby => "ruby 1.9.3dev", :bench => :for,   :tms => Bench::Tms(0.02, 0.0, 0.0, 0.0, 0.012284517288208008) }
    {:ruby => "ruby 1.9.3dev", :bench => :times, :tms => Bench::Tms(0.0,  0.0, 0.0, 0.0, 0.0024671554565429688)}
    {:ruby => "ruby 1.9.3dev", :bench => :upto,  :tms => Bench::Tms(0.0,  0.0, 0.0, 0.0, 0.0025177001953125)   }

In Bench, running a benchmark outputs something neutral, that is, a sequence of hashes. Among others, this allows analyzing benchmarking results with full relational power of [Alf](http://blambeau.github.com/alf), but that's another story. The point here is that we can simply execute the same benchmark on different ruby versions/implementations thanks to [RVM](http://beginrescueend.com/rvm/install/). As seen by Bench, the result is not different than what 'bench run' would have returned. This means that benchmarking results can be piped to 'bench report', saved somewhere, analyzed later, and so on:

    $ rvm exec bench run bench_iteration.rb
    {:ruby => "ruby 1.8.7",     :bench => :for,   :tms => Bench::Tms(0.0,0.0,0.0,0.0,0.00345611572265625)   }
    {:ruby => "ruby 1.8.7",     :bench => :times, :tms => Bench::Tms(0.01,0.0,0.0,0.0,0.00325107574462891)  }
    {:ruby => "ruby 1.8.7",     :bench => :upto,  :tms => Bench::Tms(0.0,0.0,0.0,0.0,0.00334000587463379)   }
    {:ruby => "ruby 1.9.3dev",  :bench => :for,   :tms => Bench::Tms(0.0,0.0,0.0,0.0,0.0024805068969726562) }
    {:ruby => "ruby 1.9.3dev",  :bench => :times, :tms => Bench::Tms(0.010000000000000009,0.0,0.0,0.0,0.007232666015625) }
    {:ruby => "ruby 1.9.3dev",  :bench => :upto,  :tms => Bench::Tms(0.010000000000000009,0.0,0.0,0.0,0.008184194564819336)}
    {:ruby => "jruby 1.6.3",    :bench => :for,   :tms => Bench::Tms(0.0499999523162842,0.0,0.0,0.0,0.0499999523162842) }
    {:ruby => "jruby 1.6.3",    :bench => :times, :tms => Bench::Tms(0.0149998664855957,0.0,0.0,0.0,0.0149998664855957) }
    {:ruby => "jruby 1.6.3",    :bench => :upto,  :tms => Bench::Tms(0.0120000839233398,0.0,0.0,0.0,0.0120000839233398) }

## Comparing results

Bench comes with a few commands to report and compare benchmarking results. One of them is 'bench report', which simply taskes a sequence of hashes as input, and lets regrouping and comparing results easily. For example, suppose that we would like to compare the different iteration methods, per ruby version. Here is how it goes:

    $ rvm exec bench run bench_iteration.rb | bench report --hierarchy --regroup=ruby,bench
    +----------------+------------------------------------------------------------+
    | :ruby          | :measure                                                   |
    +----------------+------------------------------------------------------------+
    | ruby 1.8.7     | +--------+-----------------------------------------------+ |
    |                | | :bench | :measure                                      | |
    |                | +--------+-----------------------------------------------+ |
    |                | | :for   |   0.020000   0.000000   0.020000 (  0.009876) | |
    |                | | :times |   0.000000   0.000000   0.000000 (  0.003214) | |
    |                | | :upto  |   0.000000   0.000000   0.000000 (  0.003860) | |
    |                | +--------+-----------------------------------------------+ |
    | ruby 1.9.3dev  | +--------+-----------------------------------------------+ |
    |                | | :bench | :measure                                      | |
    |                | +--------+-----------------------------------------------+ |
    |                | | :for   |   0.005000   0.000000   0.005000 (  0.004987) | |
    |                | | :times |   0.000000   0.000000   0.000000 (  0.002628) | |
    |                | | :upto  |   0.005000   0.000000   0.005000 (  0.005142) | |
    |                | +--------+-----------------------------------------------+ |
    | ...            | ...                                                        |

Or the other way around? Comparing rubies on each iteration method:

    $ rvm exec bench run bench_iteration.rb | bench report --hierarchy --regroup=bench,ruby
    +--------+--------------------------------------------------------------------+
    | :bench | :measure                                                           |
    +--------+--------------------------------------------------------------------+
    | :for   | +----------------+-----------------------------------------------+ |
    |        | | :ruby          | :measure                                      | |
    |        | +----------------+-----------------------------------------------+ |
    |        | | ruby 1.8.7     |   0.010000   0.000000   0.010000 (  0.009677) | |
    |        | | ruby 1.9.3dev  |   0.005000   0.000000   0.005000 (  0.005175) | |
    |        | | jruby 1.6.3    |   0.071000   0.000000   0.071000 (  0.071000) | |
    |        | +----------------+-----------------------------------------------+ |
    | :times | +----------------+-----------------------------------------------+ |
    |        | | :ruby          | :measure                                      | |
    |        | +----------------+-----------------------------------------------+ |
    |        | | ruby 1.8.7     |   0.000000   0.000000   0.000000 (  0.003275) | |
    |        | | ruby 1.9.3dev  |   0.005000   0.000000   0.005000 (  0.002634) | |
    |        | | jruby 1.6.3    |   0.028000   0.000000   0.028000 (  0.028000) | |
    |        | +----------------+-----------------------------------------------+ |
    | ...    | ...                                                                |

