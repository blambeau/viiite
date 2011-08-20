require 'spec_helper'
module Viiite
  class Formatter::Plot
    describe "to_data" do

      let(:data) { [ {:x => 1, :y => 10}, {:x => 2, :y => 20} ] }

      subject{ Formatter::Plot.to_data(data) }

      it "should return the expected array" do
        subject.should == [ [1,2], [10,20] ]
      end

    end
  end  
end
