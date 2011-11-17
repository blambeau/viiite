module Viiite::Benchmark::Native
  describe "zsh time parser" do

    subject{
      ZSH_TIME_PARSER.call(io)
    }

    context "on a correct input" do
      let(:io){ StringIO.new("rake spec  3.52s user 0.45s system 99% cpu 3.984 total") }
      it{ should eq(:tms => Viiite::Tms.new(3.52,0.45,0.0,0.0,3.984)) }
    end

  end
end
