---
layout: default
title: Basic benchmarking
---
# Basic benchmarking

In its simplest form, benchmarking with Viiite is similar to benchmarking with Benchmark. You start with a chunk of ruby code that defines a benchmark:

    # bench_iteration.rb
    n = 15000
    Viiite.bm do |r|
      r.report(:for)   { for i in 1..n; a = "1"; end }
      r.report(:times) { n.times do   ; a = "1"; end }
      r.report(:upto)  { 1.upto(n) do ; a = "1"; end }
    end

And you execute it!

    $ viiite report bench_iteration.rb
    +--------+----------+----------+----------+----------+
    | :bench | :user    | :system  | :total   | :real    |
    +--------+----------+----------+----------+----------+
    | :for   | 0.010000 | 0.000000 | 0.010000 | 0.013039 |
    | :times | 0.000000 | 0.000000 | 0.000000 | 0.003753 |
    | :upto  | 0.010000 | 0.000000 | 0.010000 | 0.003803 |
    +--------+----------+----------+----------+----------+

## Separation of concerns (running vs. analyzing)

Viiite is designed to make a strong separation of concerns between *running* benchmarks and *analyzing* results. In fact, the reporting above is a shortcut for a longer expression that distinguishes between these two activities:

    $ viiite run bench_iteration.rb | viiite report
    +--------+----------+----------+----------+----------+
    | :bench | :user    | :system  | :total   | :real    |
    +--------+----------+----------+----------+----------+
    | :for   | 0.010000 | 0.000000 | 0.010000 | 0.013039 |
    | :times | 0.000000 | 0.000000 | 0.000000 | 0.003753 |
    | :upto  | 0.010000 | 0.000000 | 0.010000 | 0.003803 |
    +--------+----------+----------+----------+----------+

'bench run' simply outputs ruby hashes on the standard output, as a neutral form of benchmarking raw data:

    $ viiite run bench_iteration.rb
    { :bench => :for,   :tms => Viiite::Tms(0.0,0.0,0.0,0.0,0.007663726806640625)                  }
    { :bench => :times, :tms => Viiite::Tms(0.010000000000000009,0.0,0.0,0.0,0.007062673568725586) }
    { :bench => :upto,  :tms => Viiite::Tms(0.010000000000000009,0.0,0.0,0.0,0.007016897201538086) }

This way, you can save your benchmarking data, compile them from various sources, etc. while keeping the ability of analyzing them later. For example:

    $ viiite run bench_iteration.rb > raw.rash    # .rash for 'ruby hashes'
    $ viiite run bench_iteration.rb >> raw.rash   # second exec, typically with different environment
    $ viiite report raw.rash
    +--------+----------+----------+----------+----------+
    | :bench | :user    | :system  | :total   | :real    |
    +--------+----------+----------+----------+----------+
    | :for   | 0.015000 | 0.000000 | 0.015000 | 0.013980 |
    | :times | 0.000000 | 0.000000 | 0.000000 | 0.003871 |
    | :upto  | 0.015000 | 0.000000 | 0.015000 | 0.011104 |
    +--------+----------+----------+----------+----------+

Measures above have been automatically averaged, which might not necessary fit your needs...

## Your (potential) power

Always remember that your raw data is clear, clean and neutral. In particular, Viiite has been designed to work hand-in-hand with [Alf](http://blambeau.github.com/alf), a flavor of relational algebra. Provided that you learn a bit of Alf, you should never be blocked in analyzing your benchmarking data the way **you want**. The report above is actually a shortcut on the following Alf invocation (except that 'bench report' also split the tms value in different columns):

    $  alf --text -rviiite summarize raw.rash -- bench -- measure "avg{ tms }"

What if you want the total time spent in each case?

    $  alf --text -rviiite summarize raw.rash -- bench -- total_time "sum{ tms }"

    +--------+-----------------------------------------------+
    | :bench | :total_time                                   |
    +--------+-----------------------------------------------+
    | :for   |   0.020000   0.000000   0.020000 (  0.015269) |
    | :times |   0.010000   0.000000   0.010000 (  0.014530) |
    | :upto  |   0.020000   0.000000   0.020000 (  0.014116) |
    +--------+-----------------------------------------------+

Alf gives you the full power of relational algebra to analyze your benchmarking data, that is, a **huge** power. However, using Alf is out of scope of this 'basic benchmarking' post. Also, Viiite itself comes with predefined tools for common use and common sense. Why not simply starting with them?
