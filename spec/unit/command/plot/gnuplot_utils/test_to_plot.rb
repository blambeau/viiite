require 'spec_helper'
module Viiite
  class Command::Plot
    describe GnuplotUtils, "#to_plot" do

      let(:data)    { [ {:x => 1, :y => 10}, {:x => 2, :y => 20} ] }

      let(:dataset) { {:title => "serie", :linewidth => 4, :data =>  data } }

      let(:plot)    { {:title => "plot", :series => [ dataset ] } }

      subject{ GnuplotUtils.to_plot(plot) }

      it "should return a correct plot instance" do
        subject.is_a?(Gnuplot::Plot).should be_true
        subject["title"].should == '"plot"'
      end

    end
  end  
end
