require File.expand_path('../../../spec_helper', __FILE__)
module Bench
  class Formatter::Text
    describe Row do
     
      let(:row){ Formatter::Text::Row.new(values) }

      describe "when single values are used only" do

        let(:values){ [ 10/3.0, true ] }
        specify "rendering_lines" do
          row.rendering_lines.should == ["| 3.3333333 | true |"]
          row.rendering_lines([10,5]).should == ["|  3.3333333 | true  |"]
        end

      end

      describe "when multiple-line values are used" do

        let(:values){ [ 10/3.0, [1, 2, 3] ] }

        specify "rendering_lines" do
          row.rendering_lines.should == ["| 3.3333333 | [1, |", 
                                         "|           |  2, |",
                                         "|           |  3] |",]
        end

      end

    end
  end
end
