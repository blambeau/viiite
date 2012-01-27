require 'spec_helper'
module Viiite
  describe Reporter do

    let(:config) { fixtures_config                    }
    let(:io)     { config.stdout                      }
    let(:subject){ Reporter::new(config)              }
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

  end # describe Reporter
end # module Viiite