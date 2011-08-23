require 'spec_helper'
module Viiite
  class BDB
    describe Immediate, "#dataset" do

      let(:bdb){ Immediate.new(fixtures_folder) }
      subject{ bdb.dataset(name) }

      describe "when name denotes an existing file" do
        let(:name){ File.expand_path('../existing.rash', __FILE__) }
        specify{ subject.to_a.should eq([{:name => 'existing'}]) }
      end

      describe "when the file exists in root folder (String)" do
        let(:name){ "bench_iteration" }
        it{ should be_a(Viiite::ViiiteFile) }
      end

      describe "when the file exists in root folder (Symbol)" do
        let(:name){ :bench_iteration }
        it{ should be_a(Viiite::ViiiteFile) }
      end

      describe "when the file exists in a sub folder (String)" do
        let(:name){ "Array/bench_sort" }
        it{ should be_a(Viiite::ViiiteFile) }
      end

      describe "when the file does not exist" do
        let(:name){ "NotA/Class/bench_non_existing" }
        specify{ lambda{subject}.should raise_error(::Alf::NoSuchDatasetError) }
      end

    end
  end
end
