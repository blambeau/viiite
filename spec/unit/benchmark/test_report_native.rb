require 'spec_helper'
module Viiite
  describe Benchmark, "report_native" do

    subject{ bench.to_a }

    context "when called with a parsing block" do
      let(:bench) do
        Viiite.bench do |b|
          b.report_native("ls") do |io|
            io.read.split("\n").map{|x| {:ls => x}}
          end
        end
      end
      specify{
        subject.should_not be_empty
        subject.each do |s|
          File.exists?(s[:ls]).should be_true
        end
      }
    end

  end
end # module Viiite
