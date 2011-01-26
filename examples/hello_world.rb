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
b = Bench.run('hello_world.bench') do |bench|
  bench.runs = 10000
  bench.variation_point(:ruby_version, RUBY_VERSION)
  bench.variation_point(:test, :via_reader){
    bench.run{|run| t.via_reader }
  }
  bench.variation_point(:test, :via_method){
    bench.run{|run| t.via_method }
  }
end
# b.each{|x| puts x.inspect}
s = Bench::Summarize.new{|s|
  s.by :ruby_version, :test
  s.count :runs
  s.avg :time => :avg_time
  s.sum :time => :total_time
}
a = (s << b)
puts a.collect{|h| 
  [ h[:ruby_version], h[:test], h[:avg_time].total, h[:total_time].total ].inspect
}.join("\n")
