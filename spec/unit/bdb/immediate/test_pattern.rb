require 'spec_helper'
module Viiite
  class BDB
    describe Immediate, "pattern" do

      let(:bdb){ Immediate.new(fixtures_folder+'/bdb', :pattern => '*_iteration.rb', :ext => '.rb') }

      specify{
        bdb.all?{|tuple|
          File.exists?(tuple[:file])
        }.should be_true
        bdb.to_rel.project([:name]).should eq(Alf::Relation[
          {:name => "bench_iteration"}
        ])
      }

    end
  end
end
