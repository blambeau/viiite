module Viiite
  describe Database do
    
    let(:db){ Database.new(fixtures_config) }
    
    it 'benchmarks' do
      expected = Alf::Relation[
        {:name => "bench_iteration",  :path => fixtures_folder/"bdb/bench_iteration.rb"},
        {:name => "Array/bench_sort", :path => fixtures_folder/"bdb/Array/bench_sort.rb"}
      ]
      db.benchmarks.should eq(expected)
    end
    
  end # describe Database
end # module Viiite
