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
      
      it 'should be Enumerable' do
        runner.should respond_to(:each)
        runner.should respond_to(:map)
      end

      it 'should be Alf iterable' do
        runner.should respond_to(:to_rel)
      end

    end
  end
end
