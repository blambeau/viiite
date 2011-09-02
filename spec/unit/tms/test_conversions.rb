require 'spec_helper'
module Viiite
  describe Tms, "conversions" do

    let(:tms) { Tms.new(1.0, 2.0, 3.0, 4.0, 5.0) }

    specify '#to_s' do
      tms.to_s.should eq "  1.000000   2.000000  10.000000 (  5.000000)"
    end

    specify '#to_a' do
      tms.to_a.should eq [1.0, 2.0, 3.0, 4.0, 5.0]
    end

    specify '#to_h' do
      tms.to_h.should eq :utime=>1.0, :stime=>2.0, :cutime=>3.0, :cstime=>4.0, :real=>5.0
    end

    specify '#to_ruby_literal' do
      eval(tms.to_ruby_literal).should eq tms
    end
  end
end
