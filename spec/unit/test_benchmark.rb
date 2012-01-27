require 'spec_helper'
module Viiite
  describe Benchmark do

    let(:subject){
      Viiite.bench do |viiite|
        viiite.report{ 1 + 1 }
      end
    }

    it "is obtained through Viiite.bench" do
      subject.should be_kind_of(Viiite::Benchmark)
    end

    it "is runnable" do
      res = []
      subject.run do |tuple|
        tuple.should have_key(:tms)
        tuple[:tms].should be_kind_of(Viiite::Tms)
        res << tuple
      end
      res.should_not be_empty
    end

    it 'invokes the reporter if it responds to :report' do
      reporter = Object.new.extend(Module.new{
        def report(bench)
          [:called, bench]
        end
      })
      subject.run(reporter).should eq([:called, subject])
    end

  end
end
