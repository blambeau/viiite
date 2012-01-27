require 'spec_helper'
module Viiite
  describe Benchmark, '.new' do

    dir = Path.dir
    subject{ Benchmark.new(arg) }

    after{
      subject.to_enum.to_a.size.should eq(1)
    }

    describe 'with a Proc' do
      let(:arg){ lambda{|b| b.report(:add){ 1+1 } } }
      it{ should be_a(Benchmark) }
    end

    describe 'with an existing file' do
      let(:arg){ dir/'bench_add.rb' }
      it{ should be_a(Benchmark) }
      specify{ subject.path.should eq(arg) }
    end

  end
end
