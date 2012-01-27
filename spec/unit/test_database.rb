require 'spec_helper'
module Viiite
  describe Database do

    let(:folder){ fixtures_config.benchmark_folder }
    let(:db){ Database.new(fixtures_config) }

    describe 'benchmark_name' do
      it 'resolves relative paths' do
        db.benchmark_name(Path("bench_iteration.rb")).should eq("bench_iteration")
        db.benchmark_name(Path("Array/bench_sort.rb")).should eq("Array/bench_sort")
      end
      it 'resolves absolute paths' do
        db.benchmark_name(folder/"bench_iteration.rb").should eq("bench_iteration")
        db.benchmark_name(folder/"Array/bench_sort.rb").should eq("Array/bench_sort")
      end
    end

    describe 'benchmark_files' do
      it 'coerces a single file' do
        db.benchmark_files(folder/"bench_iteration.rb").should eq([
          folder/"bench_iteration.rb"
        ])
      end
      it 'coerces a folder' do
        db.benchmark_files(folder/"Array").should eq([
          folder/"Array/bench_sort.rb"
        ])
      end
    end

    describe 'suite_tuple_for' do
      it 'coerces a single file' do
        tuple = db.suite_tuple_for(folder/"bench_iteration.rb")
        tuple[:name].should eq("bench_iteration")
        tuple[:suite].should be_a(Suite)
        tuple[:suite].files.should eq([folder/"bench_iteration.rb"])
      end
      it 'coerces a folder' do
        tuple = db.suite_tuple_for(folder/"Array")
        tuple[:name].should eq("Array")
        tuple[:suite].should be_a(Suite)
        tuple[:suite].files.should eq([folder/"Array/bench_sort.rb"])
      end
    end
    
    describe 'build_suite' do
      it 'does not recurse on a file' do
        file = folder/"bench_iteration.rb"
        db.build_suite(file).size.should eq(1)
      end
      it 'recurses on a folder' do
        db.build_suite(folder/"Array").size.should eq(2)
      end
    end
    
    it 'suite' do
      rel = db.suite
      rel.should be_a(Alf::Relation)
      rel.cardinality.should eq(4)
    end

  end # describe Database
end # module Viiite
