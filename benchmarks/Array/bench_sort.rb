class Array
  
  def self.random(size)
    Array.new(size){ Kernel.rand }
  end
  
end

require 'viiite'
Viiite.bm do |b|
  b.variation_point :ruby, Viiite.which_ruby
  b.range_over((1..10).map{|i| i*10_000}, :size) do |size|
    b.range_over(1..2, :i) do
      bench_case = Array.random(size)
      b.report(:"Array#sort") { bench_case.sort }
    end
  end
end

