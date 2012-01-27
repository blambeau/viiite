require 'spec_helper'
module Viiite
  class BDB
    describe Immediate, "enumerable" do

      let(:bdb){ Immediate.new(fixtures_config) }

      it 'return tuples with existing files' do
        bdb.each do |tuple|
          tuple[:file].exist?.should be_true
        end
      end

      it 'returns expected benchmarks' do
        expected = Alf::Relation[
          {:name => "bench_iteration"},
          {:name => "Array/bench_sort"}
        ]
        bdb.to_rel.project([:name]).should eq(expected)
      end

    end
  end
end
