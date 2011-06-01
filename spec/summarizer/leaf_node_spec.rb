require File.expand_path('../../spec_helper', __FILE__)
module Bench
  class Summarizer
    describe LeafNode do
      
      let(:summarize) {
        Summarizer.new do |s|
          s.count :id => :count
          s.sum   :id => :sum
        end
      }
      let(:tuples){ [{:id => 1}, {:id => 2}] }
      let(:leaf)  { summarize.summarize(tuples) }

      it "should have a each method" do
        leaf.to_a.should == [{:sum => 3, :count => 2}]
      end

    end
  end 
end
