require 'viiite'
Viiite.bm do |r|
  r.variation_point :ruby, Viiite.which_ruby
  r.range_over([100, 100_000, 1_000_000], :size) do |n|
    r.report(:for)   { for i in 1..n; a = "1"; end }
    r.report(:times) { n.times do   ; a = "1"; end }
    r.report(:upto)  { 1.upto(n) do ; a = "1"; end }
  end
end

