require 'spec_helper'
module Viiite
  class Benchmark
    describe Runner do

      let(:definition){ 
        Proc.new do |runner|
          b.report(:add){ 1+1 }
        end
      }
      let(:runner){ Runner.new(definition) }
      
      it 'is Enumerable' do
        runner.should respond_to(:each)
        runner.should respond_to(:map)
      end

      it 'is Alf iterable' do
        runner.should respond_to(:to_rel)
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
