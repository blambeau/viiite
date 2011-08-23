require 'spec_helper'
module Viiite
  describe BDB do

    after{
      subject.dataset("bench_iteration").should be_a(Alf::Iterator)
      subject.dataset("Array/bench_sort").should be_a(Alf::Iterator)
    }

    let(:ff){ fixtures_folder }
    let(:cached){ File.join(fixtures_folder, '.cache') }
    let(:saved) { File.join(fixtures_folder, '.saved') }

    describe '.immediate' do
      subject{ BDB.immediate(ff) }
      it{ should be_a(BDB::Immediate) }
    end

    describe '.cached with a folder' do
      subject{ BDB.cached(ff) }
      specify{
        subject.cache_folder.should eq(cached)
      }
    end

    describe '.cached with two folders' do
      subject{ BDB.cached(ff, saved) }
      specify{
        subject.cache_folder.should eq(saved)
      }
    end

    describe '.cached with a bdb' do
      subject{ BDB.cached(BDB.immediate(ff)) }
      specify{
        subject.cache_folder.should eq(cached)
      }
    end

    describe '.cached with a bdb and a cache folder' do
      subject{ BDB.cached(BDB.immediate(ff), saved) }
      specify{
        subject.cache_folder.should eq(saved)
      }
    end

  end
end # module Viiite
