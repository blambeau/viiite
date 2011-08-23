require 'viiite'
Viiite.bm do |r|
  r.report(:times) { 15.times do; a = "1"; end }
end

