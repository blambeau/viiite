require 'bench'
n = 15000
Bench.bm do |r|
  r.variation_point :ruby, Bench.which_ruby
  r.report(:for)   { for i in 1..n; a = "1"; end }
  r.report(:times) { n.times do   ; a = "1"; end }
  r.report(:upto)  { 1.upto(n) do ; a = "1"; end }
end

