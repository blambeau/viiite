# Bench

Bench brings tools to benchmark and analyze the complexity of your algorithms. 
It has been designed as an alternative to Benchmark that let your benchmarks 
evolve smoothly from simple measures to more complex infrastructures.

    [sudo] gem install bench

Bench uses [semantic versionning](http://semver.org) and has not yet reached the
public API required for 1.0.0. The safe way to require bench for now is as 
follows:

    gem "bench", "~> 0.1.0"

Learn more on the [github-pages of this project](http://blambeau.github.com/bench)!

## Links

* [Github pages with more documentation](http://blambeau.github.com/bench)
* [Source code](http://github.com/blambeau/bench)

## From simple measures ...

```ruby
require 'bench'
n = 15000
Bench.bm do |r|
  r.variation_point :ruby, Bench.which_ruby
  r.report(:for)   { for i in 1..n; a = "1"; end }
  r.report(:times) { n.times do   ; a = "1"; end }
  r.report(:upto)  { 1.upto(n) do ; a = "1"; end }
end
```

```terminal
$ bench report bench_iteration.rb
+--------+-----------------------------------------------+
| :bench | :measure                                      |
+--------+-----------------------------------------------+
| :for   |   0.010000   0.000000   0.010000 (  0.010454) |
| :times |   0.000000   0.000000   0.000000 (  0.002448) |
| :upto  |   0.000000   0.000000   0.000000 (  0.002451) |
+--------+-----------------------------------------------+
```

### To more complex ones ...

```terminal
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
```

### To awesomeness ...

```ruby
require 'bench'
Bench.bm do |b|
  b.variation_point :ruby, Bench.which_ruby
  b.range_over([100, 200, 300, 400, 500], :size) do |size|
    b.range_over(1..5, :i) do
      bench_case = Array.random(size)
      b.report(:quicksort) { bench_case.quicksort }
      b.report(:bubblesort){ bench_case.bubblesort }
    end
  end
end
```

```terminal
$ bench plot examples/bench_sort.rash -x size -y tms.total --graph=ruby --series=bench --gnuplot | gnuplot

                                    ruby 1.8.7

  0.35 ++-------+-------+--------+-------+--------+--------+-------+-------++
       +        +       +        +       +        +       bubblesort **A*** +
       |                                                   quicksort ##B###*A
   0.3 ++                                                               ***++
       |                                                             ***    |
  0.25 ++                                                          **      ++
       |                                                        ***         |
       |                                                     ***            |
   0.2 ++                                                 *A*              ++
       |                                              ****                  |
       |                                          ****                      |
  0.15 ++                                      ***                         ++
       |                                   ****                             |
       |                               **A*                                 |
   0.1 ++                        ******                                    ++
       |                   ******                                           |
  0.05 ++           ****A**                                                ++
       |    ********                                                        |
       A****    +       +        +       +        +        +       +########B
     0 B################B################B#################B########-------++
      100      150     200      250     300      350      400     450      500


                                  ruby 1.9.2p136

   0.1 ++-------+-------+--------+-------+--------+--------+-------+-------*A
       +        +       +        +       +        +       bubblesort **A*** +
       |                                                   quicksort **B### |
       |                                                           **       |
  0.08 ++                                                       ***        ++
       |                                                     ***            |
       |                                                  *A*               |
       |                                               ***                  |
  0.06 ++                                           ***                    ++
       |                                         ***                        |
       |                                      ***                           |
  0.04 ++                                  ***                             ++
       |                               **A*                                 |
       |                           ****                                     |
       |                       ****                                         |
  0.02 ++                  ****                                            ++
       |              **A**                                                 |
       |        ******                                                      |
       +  ******+       +        +       +        +        +       +########B
     0 A**##############B################B#################B########-------++
      100      150     200      250     300      350      400     450      500

$ bench plot examples/bench_sort.rash -x size -y tms.total --graph=ruby --series=bench
+----------------+-------------------------------------------------+
| :title         | :series                                         |
+----------------+-------------------------------------------------+
| ruby 1.8.7     | +-------------+-------------+-----------------+ |
|                | | :title      | :with       | :data           | |
|                | +-------------+-------------+-----------------+ |
|                | | :bubblesort | linespoints | +-----+-------+ | |
|                | |             |             | | :x  | :y    | | |
|                | |             |             | +-----+-------+ | |
|                | |             |             | | 100 | 0.014 | | |
|                | |             |             | | 200 | 0.056 | | |
|                | |             |             | | 300 | 0.118 | | |
|                | |             |             | | 400 | 0.202 | | |
|                | |             |             | | 500 | 0.314 | | |
|                | |             |             | +-----+-------+ | |
|                | | :quicksort  | linespoints | +-----+-------+ | |
|                | |             |             | | :x  | :y    | | |
|                | |             |             | +-----+-------+ | |
|                | |             |             | | 100 | 0.000 | | |
|                | |             |             | | 200 | 0.000 | | |
|                | |             |             | | 300 | 0.002 | | |
|                | |             |             | | 400 | 0.008 | | |
|                | |             |             | | 500 | 0.010 | | |
|                | |             |             | +-----+-------+ | |
|                | +-------------+-------------+-----------------+ |
| ruby 1.9.3dev  | +-------------+-------------+-----------------+ |
|                | | :title      | :with       | :data           | |
|                | +-------------+-------------+-----------------+ |
|                | | :bubblesort | linespoints | +-----+-------+ | |
|                | |             |             | | :x  | :y    | | |
|                | |             |             | +-----+-------+ | |
|                | |             |             | | 100 | 0.002 | | |
|                | |             |             | | 200 | 0.018 | | |
|...             | | ...         | ...         | ...               |
```

## On the devel side

Fork the project on github ... and so on. 
