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

    describe '.cached' do
      subject{ BDB.cached(fixtures_folder) }
      it{ should be_a(BDB) }
    end

  end
end # module Viiite
