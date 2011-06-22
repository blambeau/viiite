# Bench

Benchmarking and complexity analyzer utility

**This project is an investigation so far**. I'm still in the process of 
identifying benchmarking use cases and requirements. All ideas, wishes and 
contributions are of course welcome! 

## Links

* {http://rubydoc.info/github/blambeau/bench/master/frames} (read this file there!)
* {http://github.com/blambeau/bench} (source code)
* {http://revision-zero.org} (author's blog)

## Description

Bench is a ruby utility to build benchmarking suites and illustrate algorithms' 
complexity graphically. From previous experiences of mine, I've designed it with
the following requirements in mind.

### A quick and dirty DSL

Have a quick and dirty DSL for designing a benchmark with the ability to specify 
variation points

    % cat sort.bench

Here it is:

    # Let's benchmark a few sorting methods
    Bench.runner do |b|
      # Report variation point on ruby version
      b.variation_point :ruby_version, Bench.which_ruby
      # Report variation on the version of a lib
      b.variation_point :lib_version, Foo::VERSION
      # Variation point on the size of the array to sort
      b.range_over([1, 200, 400, 600, 800, 1000], :size) do |size|
        # Variation point for statistical validity
        b.range_over(1..10, :i) do
          # Generate the same benchmarking case for everybody
          bench_case = Array.random(size)
          # Variation point on benchmarking candidates
          b.report(:test => :quicksort) { quicksort  bench_case }
          b.report(:test => :bubblesort){ bubblesort bench_case }
          b.report(:test => :rubysort)  { rubysort   bench_case }
          b.report(:test => :rubysort!) { rubysort!  bench_case }
        end
      end
    end

### Compare rubies

Be able to run the same benchmark on different ruby versions, save the results
somewhere for later comparison:
  
    % rvm exec bench run sort.bench > results.rash

### Compare code versions
      
Be able to run the same benchmark on different versions of the analyzed piece
of code, save the results somewhere for later comparison:
  
    % git checkout v1.0.0
    % bench run sort.bench > results.rash
    % git checkout master
    % bench run sort.bench >> results.rash

### Query results in thousands ways

Be able to summarize results in any way I want, with 
{http://rubydoc.info/github/blambeau/alf/master/frames a powerful tool called Alf}
  
* What are jruby results specifically?

        % alf restrict results.rash -- "ruby_version =~ /jruby/" | alf summarize --by=test,size -- time "avg(:real)" | alf group -- size time -- data | alf show
        
        +-------------+-----------------------+
        | :test       | :data                 |
        +-------------+-----------------------+
        | :bubblesort | +-------+-----------+ |
        |             | | :size | :time     | |
        |             | +-------+-----------+ |
        |             | |   250 | 0.0627000 | |
        |             | |   500 | 0.0951000 | |
        |             | |   750 | 0.2095000 | |
        |             | |  1000 | 0.3591000 | |
        |             | +-------+-----------+ |
        | :quicksort  | +-------+-----------+ |
        |             | | :size | :time     | |
        |             | +-------+-----------+ |
        |             | |   250 | 0.0091000 | |
        |             | |   500 | 0.0100000 | |
        |             | |   750 | 0.0050999 | |
        |             | |  1000 | 0.0029000 | |
        |             | +-------+-----------+ |
        | :rubysort   | +-------+-----------+ |
        |             | | :size | :time     | |
        |             | +-------+-----------+ |
        |             | |   250 | 0.0010000 | |
        ...
      
* Could we compare rubies on bubblesort results?

        % alf restrict results.rash -- "test == :bubblesort" | alf summarize --by=ruby_version,size -- time "avg(:utime)" | alf group -- ruby_version time -- data | alf show
        
        +-------+--------------------------------+
        | :size | :data                          |
        +-------+--------------------------------+
        |   250 | +----------------+-----------+ |
        |       | | :ruby_version  | :time     | |
        |       | +----------------+-----------+ |
        |       | | jruby 1.6.2    | 0.0627000 | |
        |       | | ruby 1.8.7     | 0.0640000 | |
        |       | | ruby 1.9.2p180 | 0.0140000 | |
        |       | | ruby 1.9.3dev  | 0.0170000 | |
        |       | +----------------+-----------+ |
        |   500 | +----------------+-----------+ |
        |       | | :ruby_version  | :time     | |
        |       | +----------------+-----------+ |
        |       | | jruby 1.6.2    | 0.0951000 | |
        |       | | ruby 1.8.7     | 0.2530000 | |
        |       | | ruby 1.9.2p180 | 0.0690000 | |
        |       | | ruby 1.9.3dev  | 0.0730000 | |
        |       | +----------------+-----------+ |
        |   750 | +----------------+-----------+ |
        |       | | :ruby_version  | :time     | |
        |       | +----------------+-----------+ |
        |       | | jruby 1.6.2    | 0.2095000 | |
        ...
      
* Perfect! Could-you please give me a beautiful gnuplot graph that compares rubies 
  on sort methods
  
        % bench plot results.rash -x size -y utime -g test -s ruby_version --gnuplot | gnuplot
        
        1.1 ++-------+-------+--------+-------+--------+--------+-------+-------++
            +        +       +        +       +        +       ruby 1.8.7 **A****A
          1 ++                                                jruby 1.6.2 ##B***++
        0.9 ++                                              ruby 1.9.3dev $*C$$$++
            |                                              ruby 1.9.2p180**%D%%% |
        0.8 ++                                                       ***        ++
            |                                                     ***            |
        0.7 ++                                                  **              ++
        0.6 ++                                               ***                ++
            |                                            **A*                    |
        0.5 ++                                       ****                       ++
        0.4 ++                                   ****                           ++
            |                                ****                             ###B
        0.3 ++                           ****                         ########$$$C
            |                      ***A**                      #######$$$$$$%%   |
        0.2 ++             ********              ##########B###$$%%%%%          ++
        0.1 ++      *******###########B##########$$$$$%%%%%D%%%                 ++
            +   A***#######$$$$$$$$$$$C$$$$$%%%%%      +        +       +        +
          0 ++--C$$$$$$$$$$--+--------+-------+--------+--------+-------+-------++
           200      300     400      500     600      700      800     900      1000
       
## Ideas (quick memo about stuff to add)

* Benchmarking with stdlib is often used in very straighforward scenarios, as 
  illustrated below (with credits to 
  {http://on-ruby.blogspot.com/2008/12/benchmarking-makes-it-better.html 
  http://on-ruby.blogspot.com/} . Bench should at least provide a way to execute 
  benchmarks as easily: 

    blambeau@kali:~$ cat /tmp/bench.rb 
    require 'benchmark'
    n = 5_000_000
    Benchmark.bm(15) do |x|
      x.report("for loop:")   { for i in 1..n; a = "1"; end }
      x.report("times:")      { n.times do   ; a = "1"; end }
      x.report("upto:")       { 1.upto(n) do ; a = "1"; end }
    end
    
    blambeau@kali:~$ ruby /tmp/bench.rb 
                         user     system      total        real
    for loop:        1.430000   0.000000   1.430000 (  1.437242)
    times:           1.420000   0.000000   1.420000 (  1.420435)
    upto:            1.410000   0.000000   1.410000 (  1.409634)

* 'rake bench', of course.

