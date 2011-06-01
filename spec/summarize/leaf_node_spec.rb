require File.expand_path('../../spec_helper', __FILE__)
module Bench
  class Summarize
    describe LeafNode do
      
      let(:summarize) {
        Summarize.new do |s|
          s.count :id => :count
          s.sum   :id => :sum
        end
      }
      let(:leaf)  { summarize.root }
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
