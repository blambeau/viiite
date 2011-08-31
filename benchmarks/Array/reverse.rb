Viiite.bench do |b|
  b.variation_point :ruby, Viiite.which_ruby
  b.range_over((1..10).map{|i| i*10_000}, :size) do |size|
    bench_case = Array.new(size) { rand }
    b.report(:"Array#reverse")  { bench_case.reverse }
    b.report(:"Array#reverse!") { bench_case.reverse! }
  end
end
