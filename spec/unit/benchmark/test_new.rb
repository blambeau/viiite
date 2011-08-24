require 'spec_helper'
module Viiite
  describe Benchmark, '.new' do

    subject{ Benchmark.new(arg) }

    after{
      subject.to_a.size.should eq(1)
      subject.to_a.first.keys.sort{|k1,k2| 
        k1.to_s <=> k2.to_s
      }.should eq([:bench, :tms])
    }

    describe 'with a Proc' do
      let(:arg){ Proc.new{|bm| bm.report(:add){ 1+1 } } }
      it{ should be_a(Benchmark) }
    end

    describe 'with an existing file' do
      let(:arg){ File.expand_path('../bench_add.rb', __FILE__) }
      it{ should be_a(Benchmark) }
    end

    describe 'with an IO' do
      let(:arg){ File.open(File.expand_path('../bench_add.rb', __FILE__), 'r') }
      it{ should be_a(Benchmark) }
    end

  end
end
