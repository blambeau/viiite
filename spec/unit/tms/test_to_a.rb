require 'spec_helper'
module Viiite
  describe Tms, "#to_a" do

    subject{ tms.to_a }
    let(:tms){ Tms.new(1.0, 2.0, 3.0, 4.0, 5.0) }

    it{ should eq([1.0, 2.0, 3.0, 4.0, 5.0]) }

  end
end
