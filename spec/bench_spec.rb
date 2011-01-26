require File.expand_path('../spec_helper', __FILE__)
describe Bench do
  
  it "should have a version number" do
    Bench.const_defined?(:VERSION).should be_true
  end
  
end
