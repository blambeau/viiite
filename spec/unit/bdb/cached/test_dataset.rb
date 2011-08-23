require 'spec_helper'
module Viiite
  class BDB
    describe Cached, "#dataset" do

      let(:folder){ File.join(fixtures_folder, '.cache') }
      let(:bdb)   { Cached.new(delegate, folder)         }
      subject     { bdb.dataset(name)                    }

      describe "when the benchmark exists" do
        let(:delegate){
          @delegate ||= Object.new.extend Module.new{
            attr_reader :called
            def dataset(name)
              @called = true
              Alf::Relation[{:name => name}]
            end
          }
        }
        let(:name)  { "bench_iteration"                 }
        let(:cached){ File.join(folder, "#{name}.rash") }
        after{
          File.exists?(cached).should be_true 
          FileUtils.rm_rf(cached) 
        }

        describe 'when the cache file does not exist yet' do
          before{ 
            File.exists?(cached).should be_false 
          }
          specify{ 
            subject.should be_a(Alf::Reader)
            subject.to_a.should eq([{:name => "bench_iteration"}])
            delegate.called.should be_true 
          }
        end

        describe 'when the cache file already exists' do
          before{ 
            File.open(cached, "w") do |io| 
              io << "{:name => 'bench_iteration'}"
            end
          }
          specify{ 
            subject.should be_a(Alf::Reader)
            subject.to_a.should eq([{:name => "bench_iteration"}])
            delegate.called.should be_false 
          }
        end

      end

      describe "when the benchmark does not exist" do
        let(:delegate){ 
          Object.new.extend Module.new{
            def dataset(name); raise Alf::NoSuchDatasetError; end
          }
        } 
        let(:name){ "NotA/Class/bench_non_existing" }
        specify{ lambda{subject}.should raise_error(Alf::NoSuchDatasetError) }
      end

    end
  end
end
