require 'spec_helper'
module Viiite
  describe Suite do

    let(:config){ fixtures_config }

    shared_examples_for("A benchmark suite") do

      it{ should be_a(Enumerable) }

      it{ should_not be_empty     }

      it 'should contain Benchmark instances only' do
        subject.all?{|b| b.is_a?(Benchmark)}.should be_true
      end

      it 'should run without failure' do
        seen = []
        subject.run do |t| seen << t; end
        seen.should_not be_empty
      end

      it 'invokes the reporter if it responds to :report' do
        reporter = Object.new.extend(Module.new{
          def report(suite); [:called, suite]; end
        })
        subject.run(reporter).should eq([:called, subject])
      end
    end

    context "on a single file" do
      let(:subject){ Suite.new(config, config.benchmark_folder/"bench_iteration.rb") }

      it_should_behave_like("A benchmark suite")

      it 'should contain one Benchmark only' do
        subject.to_a.size.should eq(1)
      end

      it 'should contain the expected benchmark' do
        subject.files.should eq([config.benchmark_folder/"bench_iteration.rb"])
      end
    end

    context "on a folder" do
      let(:subject){ Suite.new(config, config.benchmark_folder) }

      it_should_behave_like("A benchmark suite")

      it 'should contain the expected benchmarkf' do
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