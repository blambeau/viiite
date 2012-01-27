require 'spec_helper'
module Viiite
  module Reporter
    describe Rash do
      
      it 'outputs hash literals' do
        io = StringIO.new
        reporter = Reporter::Rash.new(io)
        reporter.call(:ruby => "rules the world")
        io.string.should eq(%Q{{:ruby => "rules the world"}\n})
      end
      
    end # describe Rash
  end # module Reporter
end # module Viiite