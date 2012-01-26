require "spec_helper"
module Viiite
  describe Configuration do
    
    let(:config){ Configuration.new }
    
    it 'has benchmark_folder accessors' do
      config.benchmark_folder.should eq("benchmarks")
      config.benchmark_folder = "test"
      config.benchmark_folder.should eq(Path("test"))
    end
    
    it 'has benchmark_pattern accessors' do
      config.benchmark_pattern.should eq("**/*.rb")
      config.benchmark_pattern = "bench_*.rb"
      config.benchmark_pattern.should eq("bench_*.rb")
    end

    it 'has cache accessors' do
      config.cache.should eq(true)
      config.cache = "false"
      config.cache.should eq(false)
    end
    
  end
end