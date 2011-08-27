require 'viiite'
n = 1000
Viiite.bench do |r|
  r.variation_point :ruby, Viiite.which_ruby
  r.report(:for)   { for i in 1..n; a = "1"; end }
  r.report(:times) { n.times do   ; a = "1"; end }
  r.report(:upto)  { 1.upto(n) do ; a = "1"; end }
end

