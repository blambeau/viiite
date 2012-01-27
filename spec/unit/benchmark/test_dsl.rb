require 'spec_helper'
module Viiite
  class Benchmark
    describe DSL do
      include DSL

      def output(tuple)
        @output ||= []
        @output << tuple
      end

      def rel(&defn)
        @output = nil
        dsl_run(defn)
        @output
      end

      it 'supports reporting nothing' do
        rel do |dsl|
          dsl.report
        end.should eq([{}])
      end

      it "supports variation points" do
        rel do |dsl|
          2.times do |i|
            dsl.variation_point(:"#run", i)
            dsl.report
          end
        end.map{|t| t[:'#run']}.should eq([0, 1])
      end

      it "supports ranging over values" do
        rel do |dsl|
          dsl.range_over [10, 100, 1000], :times do |t|
            dsl.report
          end
        end.map{|t| t[:times]}.should == [10, 100, 1000]
      end

      it "supports ranging over values with implicit parameter name", :ruby => 1.9 do
        rel do |dsl|
          dsl.range_over [10, 100, 1000] do |size|
            dsl.report
          end
        end.map{|t| t[:size]}.should == [10, 100, 1000]
      end

      it "supports nested #with, #variation_point and #range_over" do
        x = rel do |dsl|
          dsl.variation_point :all, true
          dsl.variation_point(:ruby, :ruby) do
            dsl.variation_point :for_bench1, true
            dsl.range_over(1..2, :i) do
              dsl.report(:bench1)
              dsl.variation_point :ignored, nil
            end
          end
          dsl.with(:a => :b) do
            dsl.report(:bench2)
          end
        end.map{|t| t.delete(:tms); t}.should eq([
          {:all => true, :ruby => :ruby, :for_bench1 => true, :i => 1, :bench => :bench1},
          {:all => true, :ruby => :ruby, :for_bench1 => true, :i => 2, :bench => :bench1},
          {:all => true, :a => :b, :bench => :bench2}
        ])
      end

      it 'provides info about ruby' do
        rel do |dsl|
          dsl.variation_point :which, RubyFacts.which_ruby
          dsl.report
        end.first.should have_key(:which)
      end

    end
  end
end
