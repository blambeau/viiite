# Viiite

Viiite brings tools to benchmark and analyze the complexity of your algorithms. 
It has been designed as an alternative to Benchmark that let your benchmarks 
evolve smoothly from simple measures to more complex infrastructures.

    [sudo] gem install viiite

Viiite uses [semantic versionning](http://semver.org) and has not yet reached the
public API required for 1.0.0. The safe way to require viiite for now is as 
follows:

    gem "viiite", "~> 0.1.0"

Learn more on the [github-pages of this project](http://blambeau.github.com/viiite)!

## Links

* [Github pages with more documentation](http://blambeau.github.com/viiite)
* [Source code](http://github.com/blambeau/viiite)

## From simple measures ...

```ruby
require 'viiite'
n = 15000
Viiite.bm do |r|
  r.report(:for)   { for i in 1..n; a = "1"; end }
  r.report(:times) { n.times do   ; a = "1"; end }
  r.report(:upto)  { 1.upto(n) do ; a = "1"; end }
end
```

```terminal
$ viiite report bench_iteration.rb
+--------+----------+----------+----------+----------+
| :bench | :user    | :system  | :total   | :real    |
+--------+----------+----------+----------+----------+
| :for   | 0.010000 | 0.000000 | 0.010000 | 0.013039 |
| :times | 0.000000 | 0.000000 | 0.000000 | 0.003753 |
| :upto  | 0.010000 | 0.000000 | 0.010000 | 0.003803 |
+--------+----------+----------+----------+----------+
```

## To more complex ones ...

```ruby
require 'viiite'
n = 15000
Viiite.bm do |r|
  r.variation_point :ruby, Viiite.which_ruby
  r.report(:for)   { for i in 1..n; a = "1"; end }
  r.report(:times) { n.times do   ; a = "1"; end }
  r.report(:upto)  { 1.upto(n) do ; a = "1"; end }
end
```

```terminal
$ rvm exec viiite run bench_iteration.rb | viiite report --hierarchy --regroup=bench,ruby
+--------+-------------------------------------------------------+
| :bench | :measure                                              |
+--------+-------------------------------------------------------+
| :for   | +----------------+-------+---------+--------+-------+ |
|        | | :ruby          | :user | :system | :total | :real | |
|        | +----------------+-------+---------+--------+-------+ |
|        | | ruby 1.8.7     | 0.000 |   0.000 |  0.000 | 0.004 | |
|        | | ruby 1.9.3dev  | 0.010 |   0.000 |  0.010 | 0.014 | |
|        | +----------------+-------+---------+--------+-------+ |
| :times | +----------------+-------+---------+--------+-------+ |
|        | | :ruby          | :user | :system | :total | :real | |
|        | +----------------+-------+---------+--------+-------+ |
|        | | ruby 1.8.7     | 0.020 |   0.000 |  0.020 | 0.018 | |
|        | | ruby 1.9.3dev  | 0.010 |   0.000 |  0.010 | 0.004 | |
|        | +----------------+-------+---------+--------+-------+ |
| :upto  | +----------------+-------+---------+--------+-------+ |
|        | | :ruby          | :user | :system | :total | :real | |
|        | +----------------+-------+---------+--------+-------+ |
|        | | ruby 1.8.7     | 0.010 |   0.000 |  0.010 | 0.004 | |
|        | | ruby 1.9.3dev  | 0.010 |   0.000 |  0.010 | 0.011 | |
|        | +----------------+-------+---------+--------+-------+ |
+--------+-------------------------------------------------------+
```

## To awesomeness ...

```ruby
require 'viiite'
Viiite.bm do |b|
  b.variation_point :ruby, Viiite.which_ruby
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
$ viiite plot bench_sort.rb -x size -y tms.total --graph=viiite --series=ruby --gnuplot | gnuplot
                                    bubblesort

  0.35 ++-------+-------+--------+-------+--------+--------+-------+-------++
       +        +       +        +       +        +       ruby 1.8.7 **A*** +
       |                                               ruby 1.9.3dev ##B### |
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
   0.1 ++                        ******                             ########B
       |                   ******                      ####B########        |
  0.05 ++           ****A**                   #########                    ++
       |    ********             ########B####                              |
       A****    ########B########+       +        +        +       +        +
     0 B########+-------+--------+-------+--------+--------+-------+-------++
      100      150     200      250     300      350      400     450      500


                                      quicksort

  0.012 ++-------+-------+--------+-------+--------+-------+--------+------++
        +        +       +        +       +        +      ruby 1.8.7+**A*** +
        |                                              ruby 1.9.3dev ##B### |
   0.01 ++                                                                **A
        |                                                           ******  |
        |                                                     ******        |
  0.008 ++                                                 A**             ++
        |                                                **                 |
        |                                              **                   |
        |                                             *                     B
  0.006 ++                                          **                    ##+
        |                                         **                    ##  |
        |                                       **                     #    |
  0.004 ++                                     *                     ##    ++
        |                                    **                    ##       |
        |                                  **                    ##         |
  0.002 ++             ##B##############**A########             #          ++
        |        ######           ******           ######     ##            |
        +  ######+       +  ******+       +        +     ##+##      +       +
      0 A****************A**------+-------+--------+-------B--------+------++
       100      150     200      250     300      350     400      450     500

```

## On the devel side

Fork the project on github ... and so on. 
