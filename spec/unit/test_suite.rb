require 'spec_helper'
module Viiite
  describe Suite do

    let(:config){ fixtures_config }
    let(:bench){ Viiite.bench(config.benchmark_folder/"bench_iteration.rb") }
    let(:suite){ Suite.new(config, [bench])   }
    
    subject{ suite }

    it_should_behave_like "A Unit"
    
    it 'should have the expected files' do
      suite.files.should eq([config.benchmark_folder/"bench_iteration.rb"])
    end

  end # describe Suite
end # module Viiite