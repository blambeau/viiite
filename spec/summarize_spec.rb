require File.expand_path('../spec_helper', __FILE__)
module Bench
  describe "Summarize /" do
    
    it "should support a bulk computation" do
      s = Summarize.new{|s|
        s.by    :algorithm
        s.count :"#invocations"
        s.avg   :time
      }
      (s << [
        {:algorithm => "hello1", :time => 12.0},
        {:algorithm => "hello1", :time => 8.0},
        {:algorithm => "hello2", :time => 6.0},
      ]).should == [
        {:algorithm => "hello1", :"#invocations" => 2, :time => 10.0},
        {:algorithm => "hello2", :"#invocations" => 1, :time => 6.0}
      ]
    end
    
  end # Summarize
end # module Bench