require File.expand_path('../../spec_helper', __FILE__)
module Bench
  class Summarizer
    describe PivotNode do
      
      let(:summarize) {
        Summarizer.new do |s|
          s.pivot :ruby_version
          s.sum   :total => :sum
        end
      }
      let(:tuples){ [ {:ruby_version => "1.8.6", :total => 2}, 
                      {:ruby_version => "1.8.7", :total => 4}, 
                      {:ruby_version => "1.8.6", :total => 3} ] }
      let(:pivot) { summarize.summarize(tuples) }

      it "should have a each method" do
        pivot.to_a.should == [{ "1.8.6" => [ {:sum => 5} ],
                                "1.8.7" => [ {:sum => 4} ]  }]
      end

    end
  end 
end
