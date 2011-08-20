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
$ bench show bench_iteration.rb
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
$ rvm exec bench run bench_iteration.rb | bench show --hierarchy --regroup=bench,ruby
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

## On the devel side

Fork the project on github ... and so on. 
