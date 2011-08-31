require 'spec_helper'
module Viiite
  class Command
    describe Run do

      let(:bench_iteration){ File.expand_path('../bench_iteration.rb', __FILE__) }
      subject{
        out, err = capture_io { Run.run(argv) }
        rel = Alf::Reader.reader(StringIO.new(out)).to_rel
        rel = rel.project([:tms], {:allbut => true})
      }

      describe "when passed a benchmark file" do
        let(:argv){ [ bench_iteration ] }
        it{ should eq(Alf::Relation[{:bench => :times}]) }
      end

      describe "with --runs" do
        let(:argv){ [ bench_iteration, "--runs=2" ] }
        let(:expected){
          Alf::Relation[{:bench => :times, :run => 0},
                        {:bench => :times, :run => 1}]
        }
        it{ should eq(expected) }
      end

      describe "with --runs and --run-key" do
        let(:argv){ [ bench_iteration, "--runs=2", "--run-key=hello" ] }
        let(:expected){
          Alf::Relation[{:bench => :times, :hello => 0},
                        {:bench => :times, :hello => 1}]
        }
        it{ should eq(expected) }
      end

    end
  end
end
