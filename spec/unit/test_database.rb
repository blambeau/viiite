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
        db.benchmark_files(folder/"bench_iteration.rb").should eq(Alf::Relation[
          {:path => Path("bench_iteration.rb")}
        ])
      end
      it 'coerces a folder' do
        db.benchmark_files(folder/"Array").should eq(Alf::Relation[
          {:path => Path("Array/bench_sort.rb")}
        ])
      end
    end

    describe 'suite_tuple_for' do
      it 'coerces a single file' do
        db.suite_tuple_for(folder/"bench_iteration.rb").should eq(
          {:name => "bench_iteration", :files => Alf::Relation[:path => Path("bench_iteration.rb")]}
        )
      end
      it 'coerces a folder' do
        db.suite_tuple_for(folder/"Array").should eq(
          {:name => "Array", :files => Alf::Relation[:path => Path("Array/bench_sort.rb")]}
        )
      end
    end

    describe 'build_suite' do
      it 'does not recurse on a file' do
        file = folder/"bench_iteration.rb"
        db.build_suite(file).should eq([
          db.suite_tuple_for(file)
        ])
      end
      it 'recurses on a folder' do
        db.build_suite(folder/"Array").should eq([
          db.suite_tuple_for(folder/"Array"),
          db.suite_tuple_for(folder/"Array/bench_sort.rb")
        ])
      end
    end

    it 'suite' do
      expected = Alf::Relation[
        {:name => ".", :files => Alf::Relation[{:path => Path("bench_iteration.rb")}, {:path => Path("Array/bench_sort.rb")}]},
        {:name => "bench_iteration", :files => Alf::Relation[{:path => Path("bench_iteration.rb")}]},
        {:name => "Array", :files => Alf::Relation[{:path => Path("Array/bench_sort.rb")}]},
        {:name => "Array/bench_sort", :files => Alf::Relation[{:path => Path("Array/bench_sort.rb")}]}
      ]
      db.suite.should eq(expected)
    end

    it 'benchmarks' do
      expected = Alf::Relation[
        {:name => "bench_iteration",  :path => Path("bench_iteration.rb")},
        {:name => "Array/bench_sort", :path => Path("Array/bench_sort.rb")}
      ]
      db.benchmarks.should eq(expected)
    end

  end # describe Database
end # module Viiite
