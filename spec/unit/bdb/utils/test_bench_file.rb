require 'spec_helper'
module Viiite
  class BDB
    describe Utils, "#bench_file" do

      let(:utils) { Object.new.extend(Utils) }
      let(:folder){ fixtures_folder }
      subject{ utils.bench_file(folder, file, ext) }

      describe "on a file in root folder" do
        let(:file){ "bench_iteration" }
        let(:ext) { ".rb" }
        it{ should eq folder.join("bench_iteration.rb") }
      end

      describe "on a file in a sub folder" do
        let(:file){ "Array/bench_sort" }
        let(:ext) { ".rb" }
        it{ should eq folder.join("Array", "bench_sort.rb") }
      end

    end
  end
end
