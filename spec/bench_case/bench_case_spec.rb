require File.expand_path('../../spec_helper', __FILE__)
module Bench
  describe BenchCase do
    
    it "should be definable with Bench.define" do
      b = Bench.define do
        run{ 1 + 1 }
      end
      b.should be_kind_of(BenchCase)
    end

    it "should be executable" do
      b = Bench.define do run{ 1 + 1 } end
      res = []
      b.execute do |tuple|
        tuple.should have_key(:measure)
        res << tuple
      end
      res.should be_kind_of(Array)
      res.size.should == 1
      res.first[:measure].should be_kind_of(Benchmark::Tms)
    end

    it "should be enumerable" do
      b = Bench.define do run{ 1 + 1 } end
      res = b.collect do |tuple| tuple; end
      res.should be_kind_of(Array)
      res.size.should == 1
      res.first[:measure].should be_kind_of(Benchmark::Tms)
    end
    
  end
end
