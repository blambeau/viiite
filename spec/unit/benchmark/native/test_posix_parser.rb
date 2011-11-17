module Viiite::Benchmark::Native
  describe "posix 1003.2 parser" do

    subject{
      POSIX_1003_2_PARSER.call(io)
    }

    context "on a correct input" do
      let(:io){ StringIO.new("real 3.94\nuser 3.55\nsys 0.37") }
      it{ should eq(:tms => Viiite::Tms.new(3.55,0.37,0.0,0.0,3.94)) }
    end

  end
end
