Viiite.bench do |b|
  b.variation_point :ruby, Viiite.which_ruby
  b.range_over([100, 1000], :size) do |size|
    bench_case = Array.new(size) { rand }
    b.report(:"Array#sort") { bench_case.sort }
  end
end

