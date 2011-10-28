require 'spec_helper'
module Viiite
  describe Benchmark do

    it "should be definable with Viiite.bench" do
      b = Viiite.bench do |viiite|
        viiite.report{ 1 + 1 }
      end
      b.should be_kind_of(Viiite::Benchmark)
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
          viiite.report {}
        end
      end
      b.to_a.collect{|t| t[:times]}.should == [10, 100, 1000]
    end

    if RUBY_VERSION > '1.9'
      it "should support ranging over values with implicit parameter name" do
        Viiite.bench do |b|
          b.range_over [10, 100, 1000] do |size|
            b.report {}
          end
        end.to_a.map { |t| t[:size] }.should == [10, 100, 1000]
      end
    end

    it "should support nested #with, #variation_point and #range_over" do
      Viiite.bench do |r|
        r.variation_point :all, true
        r.variation_point(:ruby, :ruby) do
          r.variation_point :for_bench1, true
          r.range_over(1..2, :i) do
            r.report(:bench1) {}
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
