module Viiite
  class Suite
    describe Runner do

      let(:suite)  { Suite.new(fixtures_config, fixtures_config.benchmark_folder/"bench_iteration.rb") }
      let(:subject){ Runner.new(suite) }

      it { should be_a(Enumerable) }

      it 'should enumerate tuples' do
        subject.run do |t|
          t.should be_a(Hash)
          t[:tms].should_not be_nil
        end
      end

      it 'should return an Enumerable when invoked without reporter' do
        subject.each.should eq(subject)
        subject.run.should eq(subject)
      end

    end
  end
end