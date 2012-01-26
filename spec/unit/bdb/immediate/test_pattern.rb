require 'spec_helper'
module Viiite
  class BDB
    describe Immediate, "pattern" do

      let(:config){ fixtures_config }
      before do
        config.benchmark_pattern = "**/*_iteration.rb"
      end
      let(:bdb){ Immediate.new(config) }

      it 'return tuples with existing files' do
        bdb.each do |tuple|
          tuple[:file].exist?.should be_true
        end
      end
      
      it 'returns filtered benchmarks' do
        expected = Alf::Relation[
          {:name => "bench_iteration"},
        ]
        bdb.to_rel.project([:name]).should eq(expected)
      end

      it 'detects unsupported patterns' do
        lambda {
          config = Configuration.new{|c| c.benchmark_pattern = "blo" }
          Immediate.new(config)
        }.should raise_error(InvalidPattern)
      end

    end
  end
end
