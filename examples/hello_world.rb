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
  b.variation_point :ruby_version, Bench.short_ruby_descr
  b.range_over([1, 10, 100, 1000], :runs) do |runs|
    b.variation_point :test, :via_reader do
      b.report{ runs.times{ t.via_reader } }
    end
    b.variation_point :test, :via_method do
      b.report{ runs.times{ t.via_method } }
    end
  end
end
#bench.each{|x| puts x.inspect}

summarized = Bench::Summarizer.new{|s|
  s.by    :ruby_version, :runs
  s.pivot :test
  s.avg   :real => :avg
  s.max   :real => :max
  s.min   :real => :min
}.summarize(bench)
puts Bench.render(summarized)

