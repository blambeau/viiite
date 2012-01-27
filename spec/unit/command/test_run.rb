require 'spec_helper'
module Viiite
  class Command
    describe Run do

      let(:bench_iteration){ fixtures_folder/'command/bench_iteration.rb' }
      subject{
        out, err = capture_io { Run.run(argv) }
        rel = Alf::Reader.reader(StringIO.new(out)).to_rel
        rel = rel.project([:tms], {:allbut => true})
      }

      describe "when passed a benchmark file" do
        let(:argv){ [ bench_iteration ] }
        it{ should eq(Alf::Relation[{:bench => :times, :path => bench_iteration}]) }
      end

      describe "with --runs" do
        let(:argv){ [ bench_iteration, "--runs=2" ] }
        let(:expected){
          Alf::Relation[{:bench => :times, :run => 0, :path => bench_iteration},
                        {:bench => :times, :run => 1, :path => bench_iteration}]
        }
        it{ should eq(expected) }
      end

      describe "with --runs and --run-key" do
        let(:argv){ [ bench_iteration, "--runs=2", "--run-key=hello" ] }
        let(:expected){
          Alf::Relation[{:bench => :times, :hello => 0, :path => bench_iteration},
                        {:bench => :times, :hello => 1, :path => bench_iteration}]
        }
        it{ should eq(expected) }
      end

    end
  end
end
