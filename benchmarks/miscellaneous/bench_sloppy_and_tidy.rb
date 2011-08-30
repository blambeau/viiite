# A benchmark pioneered by @tenderlove
# @see https://gist.github.com/1170106

class Sloppy
  def sloppy; @sloppy; end
end

class Tidy
  def initialize; @tidy = nil; end
  def tidy;       @tidy; end
end

Viiite.bench do |b|
  tidy   = Tidy.new
  sloppy = Sloppy.new
  b.variation_point :ruby, Viiite.which_ruby
  b.range_over([ 1, 10, 100, 10_000, 100_000_000 ], :size) do |n|
    b.report(:tidy)   { n.times{ tidy.tidy     } }
    b.report(:sloppy) { n.times{ sloppy.sloppy } }
  end
end
