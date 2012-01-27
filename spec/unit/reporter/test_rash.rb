require 'spec_helper'
module Viiite
  module Reporter
    describe Rash do

      let(:io)     { StringIO.new                       }
      let(:subject){ Reporter::Rash.new(io)             }
      let(:tuple)  { {:ruby => "rules the world"}       }
      let(:literal){ %Q|{:ruby => "rules the world"}\n| }

      it 'outputs hash literals when called' do
        subject.call(tuple)
        io.string.should eq(literal)
      end

      it 'reports hash literals' do
        bench = [tuple]
        def bench.run; self; end
        subject.report(bench)
        io.string.should eq(literal)
      end
      
      it 'supports a delegate' do
        seen     = []
        delegate = Proc.new{|t| seen << t}
        subject  = Reporter::Rash.new(io, delegate)
        subject.call(tuple)
        seen.should eq([tuple])
      end

    end # describe Rash
  end # module Reporter
end # module Viiite