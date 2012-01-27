require 'spec_helper'
module Viiite
  describe Benchmark do

    it "is obtained through Viiite.bench" do
      b = Viiite.bench do |viiite|
        viiite.report{ 1 + 1 }
      end
      b.should be_kind_of(Viiite::Benchmark)
    end

    it "is runnable" do
      b = Viiite.bench do |viiite|
        viiite.report{ 1 + 1 }
      end
      res = []
      b.run do |tuple|
        tuple.should have_key(:tms)
        tuple[:tms].should be_kind_of(Viiite::Tms)
        res << tuple
      end
      res.should_not be_empty
    end

  end
end
