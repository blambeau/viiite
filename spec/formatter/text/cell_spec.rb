require File.expand_path('../../../spec_helper', __FILE__)
module Bench
  class Formatter::Text
    describe Cell do
     
      let(:f){ Formatter::Text::Cell.new }

      specify "text_rendering" do
        Cell.new(100).text_rendering.should == "100"
        Cell.new(:hello).text_rendering.should == ":hello"
        Cell.new("hello").text_rendering.should == "hello"
        Cell.new(10.0).text_rendering.should == "10.0000000"
        Cell.new(10/3.0).text_rendering.should == "3.3333333"
        Cell.new([]).text_rendering.should == "[]"
        Cell.new([10/3.0, true]).text_rendering.should == "[3.3333333,\n true]"
      end

      specify "min_width" do
        Cell.new("").min_width.should == 0
        Cell.new(10/3.0).min_width.should == 9
        Cell.new("12\n5345").min_width.should == 4
      end

      specify "rendering_lines" do
        Cell.new("").rendering_lines.should == []
        Cell.new(10/3.0).rendering_lines.should == ["3.3333333"]
        Cell.new([10/3.0,true]).rendering_lines.should == ["[3.3333333,", " true]"]
        Cell.new("abc").rendering_lines(5).should == ["abc  "]
        Cell.new(12).rendering_lines(5).should == ["   12"]
      end

    end
  end
end
