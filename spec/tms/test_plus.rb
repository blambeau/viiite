require 'spec_helper'
module Bench
  describe Tms, "#plus" do
  
    subject{ tms + operand }
    let(:tms){ Bench::Tms.new([1.0, 2.0, 3.0, 4.0, 5.0]) }

    describe "with an integer" do
      let(:operand){ 2 }
      specify{ 
        subject.should be_a(Tms)
        subject.to_a.should eq([3.0, 4.0, 5.0, 6.0, 7.0])
      }
    end

    describe "with another tms" do
      let(:operand){ tms }
      specify{ 
        subject.should be_a(Tms)
        subject.to_a.should eq([2.0, 4.0, 6.0, 8.0, 10.0])
      }
    end

  end
end

