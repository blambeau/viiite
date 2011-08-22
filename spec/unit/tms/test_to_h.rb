require 'spec_helper'
module Viiite
  describe Tms, "#to_h" do

    subject{ tms.to_h }
    let(:tms){ Tms.coerce([1.0, 2.0, 3.0, 4.0, 5.0]) }

    it{ should eq :utime=>1.0, :stime=>2.0, :cutime=>3.0, :cstime=>4.0, :real=>5.0 }

  end
end
