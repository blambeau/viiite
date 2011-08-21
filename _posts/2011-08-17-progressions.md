---
layout: default
title: Progressions
---
# A constant amount of work in a linear progression

Do you remember this kind of experience, from Aaron Patterson's talk [ZOMG WHY IS THIS CODE SO SLOW](http://confreaks.net/videos/427-rubyconf2010-zomg-why-is-this-code-so-slow) at RubyConf 2010 ([slides](http://www.slideshare.net/tenderlove/zomg-why-is-this-code-so-slow))?

<table><tr>
<td><pre><code class="ruby">
class Foo
  
  attr_reader :bench_reader
  
  def initialize
    @bench_reader = @bench_method = 10
  end
  
  def bench_method
    @bench_method
  end
  
end
</code></pre></td>
<td>
<img src="images/bench_attr-1.8.7.jpeg" alt="attr_reader vs. method"/>
</td>
</tr>
</table>

Writing such kind of benchmark with Viiite is easy:

    # bench_attr_vs_method.rb
    require 'viiite'
    Viiite.bm do |b|
      foo = Foo.new
      b.variation_point :ruby, Viiite.which_ruby
      b.range_over([1, 100_000, 1_000_000], :runs) do |runs|
        b.report(:bench_reader){ runs.times{ foo.bench_reader } }
        b.report(:bench_method){ runs.times{ foo.bench_method } }
      end
    end

Then:

    $ viiite run bench_attr_vs_method.rb | \
      viiite plot -x runs -y tms.total --series=bench --graph=ruby --gnuplot=jpeg | \
      gnuplot > bench_attr_vs_method.jpeg

## Interpretation

This kind of benchmark can be a bit misleading. The fact that the curves are linear says nothing about the complexity of the tested algorithm. What is true, is that the delta between the different curves (precisely, the difference of their slope) is representative of the efficiency difference between bench_attr and bench_method. As Aaron himself says: *the benchmark shows a constant amount of work in a linear progression*.

Outputting a graph here is only interresting for visual reasons: the intuitive message is very clear, and that's why Aaron probably did it that way. Observe that the following way of conducting the comparison share the same information:

    # bench_attr_vs_method_2.rb
    require 'viiite'
    Viiite.bm do |b|
      foo = Foo.new
      b.variation_point :ruby, Viiite.which_ruby
      b.report(:bench_reader){ 1_000_000.times{ foo.bench_reader } }
      b.report(:bench_method){ 1_000_000.times{ foo.bench_method } }
    end

    $ rvm exec viiite run bench_attr_vs_method_2.rb | \
      viiite report --regroup=ruby,bench --hierarchy 
    +----------------+---------------------------------------------------------------+
    | :ruby          | :measure                                                      |
    +----------------+---------------------------------------------------------------+
    | ruby 1.8.7     | +---------------+----------+----------+----------+----------+ |
    |                | | :bench        | :user    | :system  | :total   | :real    | |
    |                | +---------------+----------+----------+----------+----------+ |
    |                | | :bench_method | 0.390000 | 0.000000 | 0.390000 | 0.390209 | |
    |                | | :bench_reader | 0.310000 | 0.000000 | 0.310000 | 0.327912 | |
    |                | +---------------+----------+----------+----------+----------+ |
    | ruby 1.9.3dev  | +---------------+----------+----------+----------+----------+ |
    |                | | :bench        | :user    | :system  | :total   | :real    | |
    |                | +---------------+----------+----------+----------+----------+ |
    |                | | :bench_method | 0.220000 | 0.000000 | 0.220000 | 0.222078 | |
    |                | | :bench_reader | 0.220000 | 0.000000 | 0.220000 | 0.224298 | |
    |                | +---------------+----------+----------+----------+----------+ |
    +----------------+---------------------------------------------------------------+

As you can also see here, the difference tend to disappear under ruby 1.9.3!
