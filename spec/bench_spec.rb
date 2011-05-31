require File.expand_path('../spec_helper', __FILE__)
describe Bench do
  
  it "should have a version number" do
    Bench.const_defined?(:VERSION).should be_true
  end

  it "should provide a way to have short ruby descr" do
    Bench.short_ruby_descr.should_not be_empty
  end
  
end
