require File.expand_path('../../spec_helper', __FILE__)
module Bench
  describe "Aggregator#count /" do
    
    describe "when used with an empty array" do
      subject{ Aggregator.count << [] }
      it{ should == 0 }
    end
    
    describe "when used with a non empty array" do
      subject{ Aggregator.count << [1, "17", :blambeau] }
      it{ should == 3 }
    end
    
  end # Aggregator#count
end # module Bench