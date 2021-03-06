require 'spec_helper'
module Viiite
  class Command::Plot
    describe GnuplotUtils, "#to_dataset" do

      let(:tuple) {
        {:title => "serie",
         :linewidth => 4,
         :data => [ {:x => 1, :y => 10}, {:x => 2, :y => 20} ] }
      }
      subject{ GnuplotUtils.to_dataset(tuple) }

      it "should return a correct dataset instance" do
        subject.should be_a(Gnuplot::DataSet)
        subject.title.should == "serie"
        subject.linewidth.should == 4
        subject.data.should == [ [1,2], [10,20] ]
      end

    end
  end
end
