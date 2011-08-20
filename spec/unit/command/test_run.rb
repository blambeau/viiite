require 'spec_helper'
module Bench
  class Command
    describe Run do

      subject{ Run.run(argv) }

      before{ redirect_io }
      after { restore_io  }

      describe "when passed a benchmark file" do
        let(:argv){ [bench_iteration] }
        specify{
          subject
          $stdout.string.each_line do |line|
            h = eval(line)
            h.should be_a(Hash)
            h[:tms].should be_a(Bench::Tms)
          end
        }
      end

    end
  end
end
