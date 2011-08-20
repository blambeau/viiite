---
layout: default
title: Basic benchmarking
---
# Basic benchmarking

In its simplest form, benchmarking with Viiite is very similar to the Benchmark standard library. You start by writing a chunk of ruby code that defines a benchmark:

    # bench_iteration.rb
    n = 15000
    Viiite.bm do |r|
      r.report(:for)   { for i in 1..n; a = "1"; end }
      r.report(:times) { n.times do   ; a = "1"; end }
      r.report(:upto)  { 1.upto(n) do ; a = "1"; end }
    end

And you execute it!

    $ viiite report bench_iteration.rb
    +--------+-----------------------------------------------+
    | :bench | :measure                                      |
    +--------+-----------------------------------------------+
    | :for   |   0.000000   0.000000   0.000000 (  0.007995) |
    | :times |   0.010000   0.000000   0.010000 (  0.006995) |
    | :upto  |   0.010000   0.000000   0.010000 (  0.007034) |
    +--------+-----------------------------------------------+

## Separation of concerns (running vs. analyzing)

Viiite is designed to make a strong separation of concerns between *running* benchmarks and *analyzing* results. The reporting above is actually a shortcut for a longer expression that distinguishes between the two activities:

    $ viiite run bench_iteration.rb | viiite report
    +--------+-----------------------------------------------+
    | :bench | :measure                                      |
    +--------+-----------------------------------------------+
    | :for   |   0.000000   0.000000   0.000000 (  0.007995) |
    | :times |   0.010000   0.000000   0.010000 (  0.006995) |
    | :upto  |   0.010000   0.000000   0.010000 (  0.007034) |
    +--------+-----------------------------------------------+

Let's see what 'bench run' actually does:

    $ viiite run bench_iteration.rb
    { :bench => :for,   :tms => Viiite::Tms(0.0,0.0,0.0,0.0,0.007663726806640625)                  }
    { :bench => :times, :tms => Viiite::Tms(0.010000000000000009,0.0,0.0,0.0,0.007062673568725586) }
    { :bench => :upto,  :tms => Viiite::Tms(0.010000000000000009,0.0,0.0,0.0,0.007016897201538086) }

Okay. It simply outputs ruby hashes on the standard output, as a neutral form of bencharming raw-data. This way, you can save your benchmarking data, compile them from various sources, etc. while being able to analyze them later. For example:

    $ viiite run bench_iteration.rb > raw.rash    # .rash for 'ruby hashes'
    $ viiite run bench_iteration.rb >> raw.rash   # second exec, typically with different environment
    $ viiite report raw.rash
    +--------+-----------------------------------------------+
    | :bench | :measure                                      |
    +--------+-----------------------------------------------+
    | :for   |   0.010000   0.000000   0.010000 (  0.007635) |
    | :times |   0.005000   0.000000   0.005000 (  0.007265) |
    | :upto  |   0.010000   0.000000   0.010000 (  0.007058) |
    +--------+-----------------------------------------------+

## Your (potential) power

Measures are automatically averaged by default, which might not necessary fit your needs. Raw data is clear, clean and neutral. In particular, Viiite has been designed to work hand-in-hand with [Alf](http://blambeau.github.com/alf), an flavor of relational algebra. Provided that you learn a bit of it, you should never be blocked in analyzing your benchmarking data the way **you want**. The report above is actually a shortcut on the following Alf invocation:

    $  alf --text -rviiite summarize raw.rash -- bench -- measure "avg{ tms }"

What is you want the total time spent in each case?

    $  alf --text -rviiite summarize raw.rash -- bench -- total_time "sum{ tms }"

    +--------+-----------------------------------------------+
    | :bench | :total_time                                   |
    +--------+-----------------------------------------------+
    | :for   |   0.020000   0.000000   0.020000 (  0.015269) |
    | :times |   0.010000   0.000000   0.010000 (  0.014530) |
    | :upto  |   0.020000   0.000000   0.020000 (  0.014116) |
    +--------+-----------------------------------------------+

Alf gives you the full power of relational algebra to analyze your benchmarking data, that is, a **huge** power. However, using Alf is out of scope of this 'basic benchmarking' post. Also, Viiite itself comes with predefined tools for common use and common sense. Why not simply starting with them?
