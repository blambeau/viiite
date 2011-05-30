$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'bench'

class AttrTest
  
  attr_reader :via_reader
  
  def initialize
    @via_reader = @via_method = 10
  end
  
  def via_method
    @via_method
  end
  
end

t = AttrTest.new

bench = Bench.define do |b|
  b.variation_point :ruby_version, RUBY_VERSION
  100.times do |i|
    b.variation_point :"#run", i
    b.variation_point :test, :via_reader do
      b.report{ t.via_reader }
    end
    b.variation_point :test, :via_method do
      b.report{ t.via_method }
    end
  end
end
#bench.each{|x| puts x.inspect}

s = Bench::Summarize.new{|s|
  s.by    :ruby_version, :test
  s.avg   :real
  s.count :count
}
a = (s << bench)
puts a.collect{|h| h.inspect}.join("\n")

