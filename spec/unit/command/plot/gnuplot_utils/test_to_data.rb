require 'spec_helper'
module Viiite
  class Command::Plot
    describe GnuplotUtils, "#to_data" do

      let(:data) { [ {:x => 1, :y => 10}, {:x => 2, :y => 20} ] }

      subject{ GnuplotUtils.to_data(data) }

      it "should return the expected array" do
        subject.should == [ [1,2], [10,20] ]
      end

    end
  end
end
