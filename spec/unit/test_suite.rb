require 'spec_helper'
module Viiite
  describe Suite do

    let(:config){ fixtures_config }

    context "on a single file" do
      let(:subject){ Suite.new(config, config.benchmark_folder/"bench_iteration.rb") }
      it_should_behave_like "A Unit"
      it 'contains the expected benchmark' do
        subject.benchmark_files.should eq([config.benchmark_folder/"bench_iteration.rb"])
      end
    end

    context "on a folder" do
      let(:subject){ Suite.new(config, config.benchmark_folder) }
      it_should_behave_like "A Unit"
      it 'contains the expected benchmarks' do
        subject.benchmark_files.should eq([
          config.benchmark_folder/"Array/bench_sort.rb",
          config.benchmark_folder/"bench_iteration.rb"
        ])
      end
    end

    context "on a wrong file" do
      let(:subject){ Suite.new(config, fixtures_folder/"fake_bench.rb") }
      it 'contains the expected benchmarks' do
        subject.benchmark_files.should eq([])
      end
      it 'should not raise errors' do
        subject.run{|t| }
      end
    end

  end # describe Suite
end # module Viiite