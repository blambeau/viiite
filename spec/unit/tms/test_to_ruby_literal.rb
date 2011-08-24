require 'spec_helper'
module Viiite
  describe Tms, "#to_ruby_literal" do

    it "should be such that eval leads the same value" do
      tms = Viiite::Tms.new(1.0, 2.0, 3.0, 4.0, 5.0)
      eval(tms.to_ruby_literal).should eql(tms)
    end

  end
end
