require 'spec_helper'
module Viiite
  describe Tms, "#attributes" do
    subject { Tms.new(1.0, 2.0, 3.0, 4.0, 5.0) }
    its(:utime)  { should eq 1.0 }
    its(:user)   { should eq 1.0 }
    its(:stime)  { should eq 2.0 }
    its(:system) { should eq 2.0 }
    its(:cutime) { should eq 3.0 }
    its(:cstime) { should eq 4.0 }
    its(:real)   { should eq 5.0 }
  end
end
