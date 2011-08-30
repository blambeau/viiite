require 'spec_helper'
module Viiite
  describe Tms, "#divide" do

    subject{ tms / operand }
    let(:tms){ Viiite::Tms.new(1.0, 2.0, 3.0, 4.0, 5.0) }

    describe "with an integer" do
      let(:operand){ 2 }
      specify{
        subject.should be_a(Tms)
        subject.to_a.should eq([0.5, 1.0, 1.5, 2.0, 2.5])
      }
    end

    describe "with another tms" do
      let(:operand){ tms }
      specify{
        subject.should be_a(Tms)
        subject.to_a.should eq([1.0, 1.0, 1.0, 1.0, 1.0])
      }
    end

  end
end
