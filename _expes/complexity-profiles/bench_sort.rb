# bench_sort.rb
require 'viiite'
Viiite.bm do |b|
  b.variation_point :ruby, Viiite.which_ruby
  b.range_over([100, 200, 300, 400, 500], :size) do |size|
    bench_case = Array.random(size)
    b.report(:bubblesort){ bench_case.bubblesort }
  end
end

