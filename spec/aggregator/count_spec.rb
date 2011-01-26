require File.expand_path('../../spec_helper', __FILE__)
module Bench
  describe "Aggregator#count /" do
    
    describe "when invoked without argument /" do
      
      describe "when executed with an empty array" do
        subject{ Aggregator.count << [] }
        it{ should == 0 }
      end
    
      describe "when executed on a non empty array" do
        subject{ Aggregator.count << [1, 12, 18] }
        it{ should == 3 }
      end
      
    end # without argument
    
    describe "when invoked with a symbol argument" do
      
      describe "when executed with an empty array" do
        subject{ Aggregator.count(:hello) << [] }
        it{ should == 0 }
      end
    
      describe "when executed with an array of tuples" do
        subject{ Aggregator.count(:hello) << [{:hello => 1}, {:hello => 12}] }
        it{ should == 2 }
      end
      
    end # with a symbol argument
    
    describe "when invoked with a weird argument" do
      
      it "should raise a ArgumentError" do
        lambda{ Aggregator.count(12) }.should raise_error(ArgumentError)
      end
      
    end # when invoked with a weird argument
    
  end # Aggregator#count
end # module Bench