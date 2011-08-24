require 'spec_helper'
module Viiite
  describe Tms, "#times" do
  
    subject{ tms * operand }
    let(:tms){ Viiite::Tms.new(1.0, 2.0, 3.0, 4.0, 5.0) }

    describe "with an integer" do
      let(:operand){ 2 }
      specify{ 
        subject.should be_a(Tms)
        subject.to_a.should eq([2.0, 4.0, 6.0, 8.0, 10.0])
      }
    end

    describe "with another tms" do
      let(:operand){ tms }
      specify{ 
        subject.should be_a(Tms)
        subject.to_a.should eq([1.0, 4.0, 9.0, 16.0, 25.0])
      }
    end

  end
end

