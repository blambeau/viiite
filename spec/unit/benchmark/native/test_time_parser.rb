class Viiite::Benchmark
  describe "Native.time_parser" do

    CASES = [
      [ :elapsed, 
        "1.12", 
        Viiite::Tms.coerce(1.12) ],
      [ :posix, 
        "real 3.94\nuser 3.55\nsys 0.37", 
        Viiite::Tms.new(3.55,0.37,0.0,0.0,3.94) ],
      [ :zshtime,
        "rake spec  3.52s user 0.45s system 99% cpu 3.984 total",
        Viiite::Tms.new(3.52,0.45,0.0,0.0,3.984) ]
    ]

    CASES.each do |which, str, tms| 
      context "#{which} parser" do
        let(:io){ StringIO.new(str) }
        subject{
          Native.time_parser(which).call(io)
        }
        it{ 
          should eq(:tms => tms) 
        }
      end
    end

    it "auto parser" do
      CASES.each do |_,str,tms| 
        p = Native.time_parser(:auto)
        p.call(StringIO.new(str)).should eq(:tms => tms)
      end
    end

  end
end
