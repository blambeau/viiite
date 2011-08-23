require 'spec_helper'
require 'fileutils'
module Viiite
  class BDB
    describe Cached, "#dataset" do

      let(:folder) { File.join(fixtures_folder, '.cache') }
      let(:bdb)    { Cached.new(delegate, folder)         }
      subject      { bdb.dataset(name)                    }
      before(:each){ FileUtils.rm_rf(folder)              }

      describe "when the benchmark exists" do
        let(:delegate){
          @delegate ||= Object.new.extend Module.new{
            attr_reader :called
            def benchmark(name)
              @called = true
              Alf::Relation[{:name => name}]
            end
            alias :dataset :benchmark
          }
        }
        let(:name)  { "Array/bench_sort"                            }
        let(:cached){ File.join(folder, "Array", "bench_sort.rash") }
        after{
          File.exists?(cached).should be_true 
          FileUtils.rm_rf(cached) 
        }

        describe 'when the cache file does not exist yet' do
          before{ 
            File.exists?(cached).should be_false 
          }
          specify{ 
            subject.to_a.should eq([{:name => 'Array/bench_sort'}])
            delegate.called.should be_true 
          }
        end

        describe 'when the cache file already exists' do
          before{ 
            FileUtils.mkdir_p(File.dirname(cached))
            File.open(cached, "w") do |io| 
              io << "{:name => 'Array/bench_sort'}"
            end
          }
          specify{ 
            subject.to_a.should eq([{:name => 'Array/bench_sort'}])
            delegate.called.should be_false 
          }
        end

      end

      describe "when the benchmark does not exist" do
        let(:delegate){ 
          Object.new.extend Module.new{
            def benchmark(name); raise Alf::NoSuchDatasetError; end
            alias :dataset :benchmark
          }
        } 
        let(:name){ "NotA/Class/bench_non_existing" }
        specify{ lambda{subject}.should raise_error(Alf::NoSuchDatasetError) }
      end

    end
  end
end
