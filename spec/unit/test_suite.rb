require 'spec_helper'
module Viiite
  describe Suite do

    let(:config){ fixtures_config }
    let(:bench){ Viiite.bench{|b| b.report{}} }
    let(:suite){ Suite.new(config, [bench])   }
    
    subject{ suite }

    it_should_behave_like "A Unit"

  end # describe Suite
end # module Viiite