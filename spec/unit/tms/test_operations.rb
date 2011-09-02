require 'spec_helper'
module Viiite
  describe Tms, "operations: +,-,*,/" do

    let(:tms){ Tms.new(1.0, 2.0, 3.0, 4.0, 5.0) }

    specify "with an integer" do
      (tms + 2).should eq Tms[3.0, 4.0, 5.0, 6.0, 7.0]
      (tms / 2).should eq Tms[0.5, 1.0, 1.5, 2.0, 2.5]
    end

    specify "with another tms" do
      (tms - tms).should eq Tms[0.0, 0.0, 0.0, 0.0, 0.0]
      (tms / tms).should eq Tms[1.0, 1.0, 1.0, 1.0, 1.0]
    end

    specify "the other way round" do
      (2 + tms).should eq Tms[3.0, 4.0, 5.0, 6.0, 7.0]
    end

  end
end
