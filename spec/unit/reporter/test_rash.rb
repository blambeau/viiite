require 'spec_helper'
module Viiite
  module Reporter
    describe Rash do

      let(:io){ StringIO.new }
      let(:subject){ Reporter::Rash.new(io) }

      it 'outputs hash literals when called' do
        subject.call(:ruby => "rules the world")
        io.string.should eq(%Q{{:ruby => "rules the world"}\n})
      end

      it 'reports hash literals' do
        bench = [:ruby => "rules the world"]
        def bench.run; self; end
        subject.report(bench)
        io.string.should eq(%Q{{:ruby => "rules the world"}\n})
      end

    end # describe Rash
  end # module Reporter
end # module Viiite