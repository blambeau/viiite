require File.expand_path('../../spec_helper', __FILE__)
module Bench
  describe "Aggregator#min /" do
    
    describe "when invoked without argument /" do
      
      describe "when executed with an empty array" do
        subject{ Aggregator.min << [] }
        it{ should be_nil }
      end
    
      describe "when executed on a non empty array" do
        subject{ Aggregator.min << [12, 1, 18] }
        it{ should == 1 }
      end
      
    end # without argument
    
    describe "when invoked with a symbol argument" do
      
      describe "when executed with an empty array" do
        subject{ Aggregator.min(:hello) << [] }
        it{ should be_nil }
      end
    
      describe "when executed with an array of tuples" do
        subject{ Aggregator.min(:hello) << [{:hello => 1}, {:hello => 2}] }
        it{ should == 1 }
      end
      
    end # with a symbol argument
    
    describe "when invoked with a weird argument" do
      
      it "should raise a ArgumentError" do
        lambda{ Aggregator.min(12) }.should raise_error(ArgumentError)
      end
      
    end # when invoked with a weird argument
    
  end # Aggregator#min
end # module Bench
