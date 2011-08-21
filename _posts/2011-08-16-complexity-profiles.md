---
layout: default
title: Complexity profiles
---
# Plotting complexity profiles

The [previous post](use-cases/linear-progressions) showed how Viiite can be used for plotting graphs showing a constant amount of work in a linear progression. As we've seen, these linear curves are not representative of the complexity of the algorithm or method under benchmark. Whathever the algorithm and its actual complexity, plotted curves will be linear (see [this post on my blog](http://www.revision-zero.org/benchmarking)).

In this post, we show how the complexity of an algorithm can be profiled using Viiite. Let's take a well-known bubble sort method, directly implemented in the Array class:

    # array_patch.rb
    class Array
    
      def bubblesort
        sarray = self.clone
        for i in 0..(sarray.length - 1)
          for j in 0..(sarray.length - i - 2)
            if ( sarray[j + 1] <=> sarray[j] ) == -1
              sarray[j], sarray[j + 1] = sarray[j + 1], sarray[j]
            end
          end
        end
        sarray
      end
    
    end

    $ ruby -I. -rarray_patch -e 'puts [1, 16, 5, 2, 98, 6].bubblesort.inspect'
    [1, 2, 5, 6, 16, 98]

## Writing the benchmark

Profiling the complexity of an algorithm requires varying the size of the problem it solves. In our example, the size of the array to sort. For this, we first need a generator for benchmark cases:

    # array_patch.rb continued...
    class Array
      
      def bubblesort() 
        # ... 
      end
      
      def self.random(size) 
        Array.new(size){ Kernel.rand }
      end
    
    end

    $ ruby -I. -rarray_patch -e 'puts Array.random(5).inspect'
    [0.1669548026830059, 0.7314616453961759, 0.07112821314762585, 0.6994881121420211, 0.04235770869794486]

Now, the benchmark:

    # bench_sort.rb
    require 'viiite'
    Viiite.bm do |b|
      b.variation_point :ruby, Viiite.which_ruby
      b.range_over([100, 200, 300, 400, 500], :size) do |size|
        bench_case = Array.random(size)
        b.report(:bubblesort){ bench_case.bubblesort }
      end
    end

Observe that we run the same algorithm (bubblesort) on different problems (random arrays) of increasing size. This is what complexity profiling is about.

## Executing & Reporting

    $ viiite -I. -rarray_patch report --regroup=size bench_sort.rb
    +-------+----------+----------+----------+----------+
    | :size | :user    | :system  | :total   | :real    |
    +-------+----------+----------+----------+----------+
    |   100 | 0.010000 | 0.000000 | 0.010000 | 0.003520 |
    |   200 | 0.020000 | 0.010000 | 0.030000 | 0.024389 |
    |   300 | 0.040000 | 0.000000 | 0.040000 | 0.031459 |
    |   400 | 0.060000 | 0.000000 | 0.060000 | 0.061382 |
    |   500 | 0.110000 | 0.000000 | 0.110000 | 0.104301 |
    +-------+----------+----------+----------+----------+



