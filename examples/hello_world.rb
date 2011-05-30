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

b = Bench.define do
  variation_point, :ruby_version, RUBY_VERSION
  1000.times do |i|
    variation_point :"#run", i
    variation_point(:test, :via_reader){
      run{|run| t.via_reader }
    }
    variation_point(:test, :via_method){
      run{|run| t.via_method }
    }    
  end
end

b.each{|x| puts x.inspect}
s = Bench::Summarize.new{|s|
  s.by    :ruby_version, :test
  s.avg   :time
}
a = (s << b)
puts a.collect{|h| h.inspect}.join("\n")

# [
#   {:ruby_version=>"1.8.6", :test=>:via_reader, :run=>1, :total=>0.0}
#   {:ruby_version=>"1.8.6", :test=>:via_method, :run=>1, :total=>0.0}
#   {:ruby_version=>"1.8.6", :test=>:via_reader, :run=>2, :total=>0.0}
#   {:ruby_version=>"1.8.6", :test=>:via_method, :run=>2, :total=>0.0}
#   {:ruby_version=>"1.8.6", :test=>:via_reader, :run=>3, :total=>0.0}
#   {:ruby_version=>"1.8.6", :test=>:via_method, :run=>3, :total=>0.0}
# ]
# 
# [
#   {:ruby_version=>"1.8.6", :run=>1, :via_reader => {:total=>0.0}, :via_method => {:total => 0.0}}
#   {:ruby_version=>"1.8.6", :run=>2, :via_reader => {:total=>0.0}, :via_method => {:total => 0.0}}
#   {:ruby_version=>"1.8.6", :run=>3, :via_reader => {:total=>0.0}, :via_method => {:total => 0.0}}
# ]

