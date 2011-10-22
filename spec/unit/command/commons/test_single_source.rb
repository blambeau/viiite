require 'spec_helper'
module Viiite
  class Command
    describe Commons, "#single_source" do

      let(:commons){
        Object.new.extend(Commons).
                   extend(Module.new{
          attr_accessor :requester
        })
      }
      subject{ commons.single_source(argv) }

      describe "with an empty argv" do
        let(:argv){ [] }
        it{ should be_a(Alf::Reader) }
      end

      describe "with an argv with more than one arg" do
        let(:argv){ [1, 2, 3] }
        specify{
          lambda{subject}.should raise_error(Quickl::InvalidArgument)
        }
      end

      describe "with a argv with one existing file" do
        let(:argv){ [ Path.dir/'existing.rash' ] }
        it{ should be_a(Alf::Reader) }
        specify{
          subject.to_a.should eq([{:name => 'existing'}])
        }
      end

      describe "with a argv with a benchmark name but no requester" do
        let(:argv){ [ :hello ] }
        specify{
          lambda{subject}.should raise_error(Quickl::InvalidArgument)
        }
      end

      describe 'with a argv and a requester' do
        let(:argv){ [ :hello ] }
        let(:requester){
          Object.new.extend Module.new{
            def bdb; self; end
            def dataset(name); name.to_s.upcase; end
          }
        }
        before{ commons.requester = requester }
        describe "with a block" do
          subject{
            commons.single_source(argv){|*args| args}
          }
          it{ should eq([requester, :hello]) }
        end
        describe "without block" do
          it{ should eq("HELLO") }
        end
      end


    end
  end
end
