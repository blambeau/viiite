module Viiite
  describe Database do
    
    let(:db){ Database.new(fixtures_config) }
    
    it 'benchmarks' do
      db.benchmarks.should be_a(Alf::Relation)
    end
    
  end # describe Database
end # module Viiite