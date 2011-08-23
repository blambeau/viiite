require 'spec_helper'
module Viiite
  class BDB
    describe Immediate, "enumerable" do

      let(:bdb){ Immediate.new(fixtures_folder) }

      specify{
        bdb.all?{|tuple|
          File.exists?(tuple[:file])
        }.should be_true
        bdb.to_rel.project([:name]).should eq(Alf::Relation[
          {:name => "bench_iteration"},
          {:name => "Array/bench_sort"}
        ])
      }

    end
  end
end
