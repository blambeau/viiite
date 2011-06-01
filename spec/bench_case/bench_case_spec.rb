require File.expand_path('../../spec_helper', __FILE__)
module Bench
  describe BenchCase do
    
    it "should be definable with Bench.define" do
      b = Bench.define do |bench|
        bench.report{ 1 + 1 }
      end
      b.should be_kind_of(BenchCase)
    end

    it "should be executable" do
      b = Bench.define do |bench|
        bench.report{ 1 + 1 }
      end
      res = []
      b.execute do |tuple|
        tuple.should have_key(:total)
        res << tuple
      end
      res.should be_kind_of(Array)
      res.size.should == 1
      res.first[:total].should be_kind_of(Float)
    end

    it "should be enumerable" do
      b = Bench.define do |bench|
        bench.report{ 1 + 1 }
      end
      res = b.to_a
      res.should be_kind_of(Array)
      res.size.should == 1
      res.first[:total].should be_kind_of(Float)
    end
    
    it "should support variation points" do
      b = Bench.define do |bench|
        2.times do |i| 
          bench.variation_point(:"#run", i)
          bench.report do end
        end
      end
      res = b.to_a
      res.collect{|t| t[:"#run"]}.should == [0, 1]
    end

    it "should support ranging over values" do
      b = Bench.define do |bench|
        bench.range_over [10, 100, 1000], :times do |t|
          bench.report do end
        end
      end
      b.to_a.collect{|t| t[:times]}.should == [10, 100, 1000]
    end

  end
end
