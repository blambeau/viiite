require 'spec_helper'
describe Viiite do

  it "should have a version number" do
    Viiite.const_defined?(:VERSION).should be_true
  end

  it 'respond_to short_ruby_description (compatibility)' do
    Viiite.should respond_to(:short_ruby_description)
  end

  it 'respond_to which_ruby (compatibility)' do
    Viiite.should respond_to(:which_ruby)
  end

end
