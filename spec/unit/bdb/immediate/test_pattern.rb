require 'spec_helper'
module Viiite
  class BDB
    describe Immediate, "pattern" do

      let(:bdb){ Immediate.new(fixtures_folder/'bdb', '*_iteration.rb') }

      specify{
        bdb.each{|tuple|
          File.exists?(tuple[:file]).should be_true
        }
        bdb.to_rel.project([:name]).should eq(Alf::Relation[
          {:name => "bench_iteration"}
        ])
      }

      specify{
        lambda {
          Immediate.new(fixtures_folder/'bdb', 'invalid.{a,b}')
        }.should raise_error(InvalidPattern)
      }

    end
  end
end
