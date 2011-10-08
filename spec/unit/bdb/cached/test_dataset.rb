require 'spec_helper'

module Viiite
  class BDB
    describe Cached, "#dataset" do

      let(:folder) { fixtures_folder/'.cache'     }
      let(:bdb)    { Cached.new(delegate, folder) }
      subject      { bdb.dataset(name)            }
      before(:each){ folder.rm_rf                 }

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
        let(:name)  { "Array/bench_sort"    }
        let(:cached){ folder/"#{name}.rash" }
        after{
          cached.exist?.should be_true
          cached.rm_rf
        }

        describe 'when the cache file does not exist yet' do
          before{
            cached.exist?.should be_false
          }
          specify{
            subject.to_a.should eq([{:name => 'Array/bench_sort'}])
            delegate.called.should be_true
          }
        end

        describe 'when the cache file already exists' do
          before{
            cached.dir.mkdir_p
            cached.write "{:name => 'Array/bench_sort'}"
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
