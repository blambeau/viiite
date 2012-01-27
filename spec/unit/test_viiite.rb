require 'spec_helper'
describe Viiite do

  it "should have a version number" do
    Viiite.const_defined?(:VERSION).should be_true
  end

  it 'responds to short_ruby_description' do
    Viiite.should respond_to(:short_ruby_description)
  end

  it 'responds to which_ruby' do
    Viiite.should respond_to(:which_ruby)
  end
  
  describe "bench" do

    it 'supports a block' do
      Viiite.bench{}.should be_a(Viiite::Benchmark)
    end

    it 'support a valid a path' do
      path = fixtures_folder/:bdb/"bench_iteration.rb"
      b = Viiite.bench(path)
      b.should be_a(Viiite::Benchmark)
      b.path.should eq(path)
    end
    
    it 'returns nil on an invalid path' do
      path = fixtures_folder/"fake_bench.rb"
      Viiite.bench(path).should be_nil
    end

  end

end
