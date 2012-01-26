require 'spec_helper'
module Viiite
  describe Benchmark do

    it "should be definable with Viiite.bench" do
      b = Viiite.bench do |viiite|
        viiite.report{ 1 + 1 }
      end
      b.should be_kind_of(Viiite::Benchmark)
    end

    it "should evalutate with the Runner instance only when asked" do
      Viiite.bench do |x|
        x.class.should == Viiite::Benchmark::Runner
        self.class.should_not == Viiite::Benchmark::Runner
      end.to_a

      Viiite.bench do
        self.class.should == Viiite::Benchmark::Runner
      end.to_a
    end

    it "should be executable" do
      b = Viiite.bench do |viiite|
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
      b = Viiite.bench do |viiite|
        viiite.report{ 1 + 1 }
      end
      res = b.to_a
      res.should be_kind_of(Array)
      res.size.should == 1
      res.first[:tms].should be_kind_of(Viiite::Tms)
    end

    it "should support variation points" do
      b = Viiite.bench do |viiite|
        2.times do |i|
          viiite.variation_point(:"#run", i)
          viiite.report {}
        end
      end
      res = b.to_a
      res.collect{|t| t[:"#run"]}.should == [0, 1]
    end

    it "should support ranging over values" do
      b = Viiite.bench do |viiite|
        viiite.range_over [10, 100, 1000], :times do |t|
          viiite.with :times_value => t
          viiite.report {}
        end
      end
      b.to_a.collect{|t| t[:times]}.should == [10, 100, 1000]
      b.to_a.collect{|t| t[:times_value]}.should == [10, 100, 1000]
    end

    it "should support ranging over values with implicit parameter name", :ruby => 1.9 do
      Viiite.bench do |b|
        b.range_over [10, 100, 1000] do |size|
          b.with :size_value => size
          b.report {}
        end
      end.to_a.map { |t|
        t[:size].should == t[:size_value]
        t[:size]
      }.should == [10, 100, 1000]
    end

    it "should support nested #with, #variation_point and #range_over" do
      Viiite.bench do |r|
        r.variation_point :all, true
        r.variation_point(:ruby, :ruby) do
          r.variation_point :for_bench1, true
          r.range_over(1..2, :i) do
            r.report(:bench1) {}
            r.variation_point :ignored, nil
          end
        end
        r.with(:a => :b) do
          r.report(:bench2) {}
        end
      end.to_rel.project([:tms], {:allbut => true}).should == Alf::Relation[
        {:all => true, :ruby => :ruby, :for_bench1 => true, :i => 1, :bench => :bench1},
        {:all => true, :ruby => :ruby, :for_bench1 => true, :i => 2, :bench => :bench1},
        {:all => true, :a => :b, :bench => :bench2}
      ]
    end

  end
end
