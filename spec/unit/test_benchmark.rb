require 'spec_helper'
module Viiite
  describe Benchmark do
    
    it "should be definable with Viiite.bm" do
      b = Viiite.bm do |viiite|
        viiite.report{ 1 + 1 }
      end
      b.should be_kind_of(Viiite::Benchmark)
    end

    it "should be executable" do
      b = Viiite.bm do |viiite|
        viiite.report{ 1 + 1 }
      end
      res = []
      b.each do |tuple|
        tuple.should have_key(:tms)
        res << tuple
      end
      res.should be_kind_of(Array)
      res.size.should == 1
      res.first[:tms].should be_kind_of(Viiite::Tms)
    end

    it "should be enumerable" do
      b = Viiite.bm do |viiite|
        viiite.report{ 1 + 1 }
      end
      res = b.to_a
      res.should be_kind_of(Array)
      res.size.should == 1
      res.first[:tms].should be_kind_of(Viiite::Tms)
    end
    
    it "should support variation points" do
      b = Viiite.bm do |viiite|
        2.times do |i| 
          viiite.variation_point(:"#run", i)
          viiite.report do end
        end
      end
      res = b.to_a
      res.collect{|t| t[:"#run"]}.should == [0, 1]
    end

    it "should support ranging over values" do
      b = Viiite.bm do |viiite|
        viiite.range_over [10, 100, 1000], :times do |t|
          viiite.report do end
        end
      end
      b.to_a.collect{|t| t[:times]}.should == [10, 100, 1000]
    end

  end
end
