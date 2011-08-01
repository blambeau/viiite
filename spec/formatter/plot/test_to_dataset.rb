require File.expand_path('../../../spec_helper', __FILE__)
module Bench
  class Formatter::Plot
    describe "to_dataset" do

      let(:tuple) {
        {:title => "serie", 
         :linewidth => 4,
         :data => [ {:x => 1, :y => 10}, {:x => 2, :y => 20} ] }
      }
      subject{ Formatter::Plot.to_dataset(tuple) }

      it "should return a correct dataset instance" do
        subject.should be_a(Gnuplot::DataSet)
        subject.title.should == "serie"
        subject.linewidth.should == 4
        subject.data.should == [ [1,2], [10,20] ]
      end

    end
  end  
end
