require 'spec_helper'
module Viiite
  describe BDB do

    after{
      subject.dataset("bench_iteration").should be_a(Alf::Iterator)
      subject.dataset("Array/bench_sort").should be_a(Alf::Iterator)
    }

    describe '.immediate' do
      subject{ BDB.immediate(fixtures_folder) }
      it{ should be_a(BDB) }
    end

    describe '.cached with a folder' do
      subject{ BDB.cached(fixtures_folder) }
      specify{
        subject.should be_a(BDB)
        subject.cache_folder.should eq(File.join(fixtures_folder, ".cache"))
      }
    end

    describe '.cached with a bdb' do
      subject{ BDB.cached(BDB.immediate(fixtures_folder)) }
      specify{
        subject.should be_a(BDB)
        subject.cache_folder.should eq(File.join(fixtures_folder, ".cache"))
      }
    end

  end
end # module Viiite
