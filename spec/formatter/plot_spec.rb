require File.expand_path('../../spec_helper', __FILE__)
require 'fileutils'
module Bench
  class Formatter::Plot
    describe "render" do

      let(:output)  { File.expand_path('../plot.gif', __FILE__) }
      let(:data)    { [ {:x => 1, :y => 10}, {:x => 2, :y => 20} ] }
      let(:dataset) { {:title => "serie", :with => "lines", :linewidth => 2, :data => data } }
      let(:plot)    { {:title => "plot", :terminal => "gif", :output => output, 
                       :datasets => [ dataset ] } }
      before { FileUtils.rm_rf output }

      it "should generate the graph" do
        Formatter::Plot.render(plot)
        File.exists?(output).should be_true
      end

    end
  end  
end
