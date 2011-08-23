require 'spec_helper'
module Viiite
  class BDB
    describe Immediate, "#find_benchmark_file" do

      let(:fixtures_folder){ 
        File.expand_path("../../../../fixtures", __FILE__) 
      }
      let(:bdb){ 
        Immediate.new(fixtures_folder) 
      }
      subject{ bdb.send(:find_benchmark_file, name) }

      before(:each) do
        subject.should eq(File.expand_path(subject)) if subject
      end

      describe "when name denotes an existing file" do
        let(:name){ __FILE__ }
        it{ should eq(__FILE__) }
      end

      describe "when the file exists in root folder (String)" do
        let(:name){ "bench_iteration" }
        specify{ File.exists?(subject).should be_true }
      end

      describe "when the file exists in root folder (Symbol)" do
        let(:name){ :bench_iteration }
        specify{ File.exists?(subject).should be_true }
      end

      describe "when the file exists in a sub folder (String)" do
        let(:name){ "Array/bench_sort" }
        specify{ File.exists?(subject).should be_true }
      end

      describe "when the file does not exist" do
        let(:name){ "NotA/Class/bench_non_existing" }
        specify{ subject.should be_nil }
      end

    end
  end
end
