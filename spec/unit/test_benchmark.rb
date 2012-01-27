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
    
    it_should_behave_like "A Unit"

  end
end
