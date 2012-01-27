require 'spec_helper'
shared_examples_for "A Unit" do

  let(:seen){ [] }
  let(:reporter){
    Proc.new{|tuple|
      tuple[:tms].should be_kind_of(Viiite::Tms)
      tuple[:extra].should eq("World") if tuple.has_key?(:extra)
      seen << tuple
    }
  }
  after{
    seen.should_not be_empty
  }

  context 'when called with nothing' do
    it 'should return an Enumerable when ran without argument' do
      enum = subject.run
      enum.should be_a(Enumerable)
      enum.each(&reporter)
    end
    it 'supports extra info' do
      subject.run(:extra => "World").each(&reporter)
    end
  end

  context 'when called with a block' do
    it "yields tuples" do
      subject.run(&reporter)
    end
    it 'supports extra info' do
      subject.run(:extra => "World", &reporter)
    end
  end

  context 'when called with a reporter' do
    it "yields tuples" do
      subject.run(reporter)
    end
    it 'supports extra info' do
      subject.run({:extra => "World"}, reporter)
    end
  end

end