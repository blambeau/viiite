require File.expand_path('../../../spec_helper', __FILE__)
module Bench
  class Formatter::Text
    describe Table do
     
      let(:columns){ [ :method, :total ] }
      let(:table){ Formatter::Text::Table.new(records, columns) }

      describe "on an empty table" do

        let(:records){ [ ] }

        specify "render" do
          table.render.should == "+---------+--------+\n" +
                                 "| :method | :total |\n" +
                                 "+---------+--------+\n" +
                                 "+---------+--------+\n"
        end

      end

      describe "when single values are used only" do

        let(:records){ [ [:by_x, 10.0], [:by_y, 2.0] ] }

        specify "render" do
          table.render.should == "+---------+--------+\n" +
                                 "| :method | :total |\n" +
                                 "+---------+--------+\n" +
                                 "| :by_x   |   10.0 |\n" +
                                 "| :by_y   |    2.0 |\n" +
                                 "+---------+--------+\n"
        end

      end

    end
  end
end
