class Viiite::Benchmark
  describe "Native.time_parser" do

    let(:io){ StringIO.new(str) }
    subject{
      Native.time_parser(which).call(io)
    }

    context "elapsed-time parser" do
      let(:which){ :elapsed }
      let(:str)   { "1.12" }
      it{ 
        should eq(:tms => Viiite::Tms.coerce(1.12)) 
      }
    end

    context "posix" do
      let(:which){ :posix }
      let(:str){ "real 3.94\nuser 3.55\nsys 0.37" }
      it{ should eq(:tms => Viiite::Tms.new(3.55,0.37,0.0,0.0,3.94)) }
    end

    context "zshtime" do
      let(:which){ :zshtime }
      let(:str){ "rake spec  3.52s user 0.45s system 99% cpu 3.984 total" }
      it{ should eq(:tms => Viiite::Tms.new(3.52,0.45,0.0,0.0,3.984)) }
    end

  end
end
