require File.expand_path('../../spec_helper', __FILE__)
module Bench
  class Summarize
    describe ByNode do
      
      let(:summarize) {
        Summarize.new do |s|
          s.by    :ruby_version
          s.sum   :total => :sum
        end
      }
      let(:tuples){ [ {:ruby_version => "1.8.6", :total => 2}, 
                      {:ruby_version => "1.8.7", :total => 4}, 
                      {:ruby_version => "1.8.6", :total => 3} ] }
      let(:by)    { summarize.summarize(tuples) }

      it "should have a each method" do
        by.to_a.should == [{:ruby_version => "1.8.6", :sum => 5},
                           {:ruby_version => "1.8.7", :sum => 4}]
      end

    end
  end 
end
