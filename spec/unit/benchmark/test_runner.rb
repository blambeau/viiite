require 'spec_helper'
module Viiite
  class Benchmark
    describe Runner do

      let(:definition){ 
        Proc.new do |runner|
          b.report(:add){ 1+1 }
        end
      }
      let(:subject){ Runner.new(definition) }

      it{ should be_a(Enumerable) }

      it 'should return an Enumerable when ran without reporter' do
        subject.run.should eq(subject)
        subject.each.should eq(subject)
      end

      it 'pass itself to the definition block when asked' do
        runner = Runner.new(Proc.new{|x| x.should eq(runner)})
        runner.call(nil)
      end

      it 'instance_exec the definition block otherwise' do
        runner = Runner.new(Proc.new{ with(:runner => self){ report{} } })
        seen   = nil
        runner.call(Proc.new{|t| seen = t[:runner]})
        seen.should eq(runner)
      end

    end
  end
end
