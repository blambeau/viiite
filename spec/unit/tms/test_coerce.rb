require 'spec_helper'
module Viiite
  describe Tms, ".coerce" do

    subject{ Tms.coerce(arg) }

    describe "from zero" do
      let(:arg){ 0.0 }
      specify{ 
        subject.should be_a(Tms)
        subject.to_a.should eq([0.0, 0.0, 0.0, 0.0, 0.0]) 
      }
    end

    describe "from one" do
      let(:arg){ 1.0 }
      specify{ 
        subject.should be_a(Tms)
        subject.to_a.should eq([1.0, 0.0, 0.0, 0.0, 0.0]) 
      }
    end

    describe "from a complete hash" do
      let(:arg){ {
        :utime => 1.0, 
        :stime => 2.0, 
        :cutime => 3.0, 
        :cstime => 4.0, 
        :real => 5.0, 
      } } 
      specify{ 
        subject.should be_a(Tms)
        subject.to_a.should eq([1.0, 2.0, 3.0, 4.0, 5.0]) 
      }
    end

    describe "from an array" do
      let(:arg){ [1.0, 2.0, 3.0, 4.0, 5.0] } 
      specify{ 
        subject.should be_a(Tms)
        subject.to_a.should eq([1.0, 2.0, 3.0, 4.0, 5.0]) 
      }
    end

  end
end
