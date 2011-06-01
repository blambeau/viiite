require File.expand_path('../../spec_helper', __FILE__)
module Bench
  class Summarize
    describe LeafNode do
      
      let(:count) { Aggregator.count    }
      let(:sum)   { Aggregator.sum(:id) }
      let(:leaf)  { LeafNode.new(nil, 0, :sum => sum, :count => count) }
      let(:tuples){ [{:id => 1}, {:id => 2}] }

      it "should have a each method" do
        tuples.each{|t| leaf << t}
        result = []
        leaf.each{|t| result << t}
        result.should == [{:sum => 3, :count => 2}]
      end

    end
  end 
end
