$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bench'

n = 15000
Bench.runner do |r|
  r.variation_point :ruby, Bench.which_ruby
  r.report(:test => :for)   { for i in 1..n; a = "1"; end }
  r.report(:test => :times) { n.times do   ; a = "1"; end }
  r.report(:test => :upto)  { 1.upto(n) do ; a = "1"; end }
end
