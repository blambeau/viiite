# bench_sort.rb
require 'viiite'
Viiite.bench do |b|
  b.variation_point :ruby, Viiite.which_ruby
  b.range_over([100, 300, 500, 700, 900], :size) do |size|
    b.range_over(1..5, :run) do |run|
      bench_case = Array.random(size)
      b.report(:bubblesort){ bench_case.bubblesort }
    end
  end
end

