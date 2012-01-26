require 'spec_helper'
module Viiite
  describe BDB, ".new" do

    let(:config){ Configuration.new }
    subject{ BDB.new(config) }

    describe "with default configuration" do
      specify{
        subject.should be_cached
        subject.folder.should eq(Path('benchmarks'))
        subject.cache_folder.should eq(Path('benchmarks/.cache'))
      }
    end

    describe "with a specific folder" do
      before do
        config.benchmark_folder = "/tmp"
      end
      specify{
        subject.should be_cached
        subject.folder.should eq(Path("/tmp"))
        subject.cache_folder.should eq(Path("/tmp/.cache"))
      }
    end

    describe "with cache disabled" do
      before do
        config.cache_folder = nil
      end
      specify{
        subject.should_not be_cached
        subject.folder.should eq(Path("benchmarks"))
      }
    end

    describe "with cache set to a specific folder" do
      before do
        config.cache_folder = '/tmp'
      end
      specify{
        subject.should be_cached
        subject.folder.should eq(Path("benchmarks"))
        subject.cache_folder.should eq(Path("/tmp"))
      }
    end

  end
end
