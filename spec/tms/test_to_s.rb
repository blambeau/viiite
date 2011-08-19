require 'spec_helper'
module Bench
  describe Tms, "#to_s" do

    subject{ tms.to_s }
    let(:tms){ Tms.coerce([1.0, 2.0, 3.0, 4.0, 5.0]) }

    it{ should eq("  1.000000   2.000000  10.000000 (  5.000000)") }

  end
end
