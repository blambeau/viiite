require 'spec_helper'
describe Viiite do
  
  it "should have a version number" do
    Viiite.const_defined?(:VERSION).should be_true
  end

  it "should provide a way to have short ruby descr" do
    Viiite.which_ruby.should_not be_empty
  end
  
end
