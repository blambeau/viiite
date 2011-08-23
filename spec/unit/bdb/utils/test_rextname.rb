require 'spec_helper'
module Viiite
  class BDB
    describe Utils, ".rextname" do

      let(:utils){ Object.new.extend(Utils) }
      subject{ utils.rextname(file, ".ext") }

      describe "on a file without extension" do
        let(:file){ "hello/world" }
        it{ should eq("hello/world.ext") }
      end

      describe "on a file with extension" do
        let(:file){ "hello/world.rb" }
        it{ should eq("hello/world.ext") }
      end

    end
  end
end
