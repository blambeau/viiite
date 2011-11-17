module Viiite::Benchmark::Native
  describe "elapsed_time_parser" do

    subject{
      ELAPSED_TIME_PARSER.call(io)
    }

    context "on a correct input" do
      let(:io){ StringIO.new("1.12") }
      it{ should eq(:tms => Viiite::Tms.coerce(1.12)) }
    end

  end
end
