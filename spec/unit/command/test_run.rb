require 'spec_helper'
module Viiite
  class Command
    describe Run do

      subject{ Run.run(argv) }

      before{ redirect_io }
      after { restore_io  }

      describe "when passed a benchmark file" do
        let(:argv){ [ File.expand_path('../bench_iteration.rb', __FILE__) ] }
        specify{
          subject
          $stdout.string.each_line do |line|
            (h = eval(line)).should be_a(Hash)
            h[:tms].should be_a(Viiite::Tms)
          end
        }
      end

    end
  end
end
