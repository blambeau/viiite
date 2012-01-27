require 'spec_helper'
module Viiite
  describe Suite do

    let(:config){ fixtures_config }

    shared_examples_for("A benchmark suite") do
      it_should_behave_like "A Unit"
      it{ should_not be_empty }
      it 'contains Benchmark instances only' do
        subject.all?{|b| b.is_a?(Benchmark)}.should be_true
      end
    end

    context "on a single file" do
      let(:subject){ Suite.new(config, config.benchmark_folder/"bench_iteration.rb") }
      it_should_behave_like("A benchmark suite")
      it 'contains one Benchmark only' do
        subject.to_a.size.should eq(1)
      end
      it 'contains the expected benchmark' do
        subject.files.should eq([config.benchmark_folder/"bench_iteration.rb"])
      end
    end

    context "on a folder" do
      let(:subject){ Suite.new(config, config.benchmark_folder) }
      it_should_behave_like("A benchmark suite")
      it 'contains the expected benchmarkf' do
        subject.files.should eq([
          config.benchmark_folder/"Array/bench_sort.rb",
          config.benchmark_folder/"bench_iteration.rb"
        ])
      end
    end

    context "on a wrong file" do
      let(:subject){ Suite.new(config, fixtures_folder/"fake_bench.rb") }
      it{ should be_empty }
    end

  end # describe Suite
end # module Viiite