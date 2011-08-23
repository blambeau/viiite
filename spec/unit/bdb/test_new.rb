require 'spec_helper'
module Viiite
  describe BDB, ".new" do

    subject{ BDB.new(options) } 

    describe "with default options" do
      let(:options){ {} }
      specify{ 
        subject.should be_cached 
        subject.folder.should eq("benchmarks")
        subject.cache_folder.should eq("benchmarks/.cache")
        subject.cache_mode.should eq("w")
      }
    end

    describe "with a specific folder" do
      let(:options){ {:folder => "/tmp"} }
      specify{ 
        subject.should be_cached 
        subject.folder.should eq("/tmp")
        subject.cache_folder.should eq("/tmp/.cache")
      }
    end

    describe "with cache set to false" do
      let(:options){ {:cache => false} }
      specify{ 
        subject.folder.should eq("benchmarks")
        subject.should_not be_cached 
      }
    end

    describe "with cache set to a specific folder" do
      let(:options){ {:cache => "/tmp"} }
      specify{ 
        subject.should be_cached 
        subject.folder.should eq("benchmarks")
        subject.cache_folder.should eq("/tmp")
      }
    end

  end
end
