require 'spec_helper'
module Bench
  describe Tms, "#minus" do
  
    subject{ tms - operand }
    let(:tms){ Bench::Tms.new([1.0, 2.0, 3.0, 4.0, 5.0]) }

    describe "with an integer" do
      let(:operand){ 1 }
      specify{ 
        subject.should be_a(Tms)
        subject.to_a.should eq([0.0, 1.0, 2.0, 3.0, 4.0])
      }
    end

    describe "with another tms" do
      let(:operand){ tms }
      specify{ 
        subject.should be_a(Tms)
        subject.to_a.should eq([0.0, 0.0, 0.0, 0.0, 0.0])
      }
    end

  end
end
