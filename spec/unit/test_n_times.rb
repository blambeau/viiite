module Viiite
  describe NTimes do

    let(:bench){
      Viiite.bench do |b|
        b.report{}
      end
    }

    subject{
      NTimes.new(bench, 2, :key)
    }

    it_should_behave_like "A Unit"

  end # describe NTimes
end # module Viiite