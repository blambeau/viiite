require "spec_helper"
module Viiite
  describe Configuration do

    let(:config){ Configuration.new }

    it 'yields itself at construction' do
      seen     = nil
      returned = Configuration.new{|c| seen = c}
      seen.should eq(returned)
    end

    it 'has benchmark_folder accessors' do
      config.benchmark_folder.should eq(Path("benchmarks"))
      config.benchmark_folder = "test"
      config.benchmark_folder.should eq(Path("test"))
    end

    it 'has benchmark_pattern accessors' do
      config.benchmark_pattern.should eq("**/*.rb")
      config.benchmark_pattern = "bench_*.rb"
      config.benchmark_pattern.should eq("bench_*.rb")
    end

    it 'has cache_folder accessors' do
      config.cache_folder.should eq(Path("benchmarks/.cache"))
      config.cache_folder = "cache"
      config.cache_folder.should eq(Path("cache"))
    end

    it 'supports a Proc as cache_folder' do
      config.cache_folder = Proc.new{|c| c.should eq(config); "cache" }
      config.cache_folder.should eq(Path("cache"))
    end

    it 'has stdout accessors' do
      config.stdout.should eq($stdout)
      config.stdout = StringIO.new
      config.stdout.should be_a(StringIO)
    end

    describe 'cache_enabled?' do
      it 'is enabled by default' do
        config.should be_cache_enabled
      end
      it 'depends on cache_folder' do
        config.cache_folder = nil
        config.should_not be_cache_enabled
      end
      it 'works even when cache_folder is a Proc' do
        config.cache_folder = Proc.new{|c| nil}
        config.should_not be_cache_enabled
      end
    end

    describe "cache_file_for" do
      let(:source){ config.benchmark_folder/"Array/bench_sort.rb" }
      it 'supports a Path' do
        config.cache_file_for(source).should eq(config.cache_folder/'Array/bench_sort.rash')
      end
      it 'works with unrelated cache folder' do
        config.cache_folder = '/tmp'
        config.cache_file_for(source).should eq(Path("/tmp/Array/bench_sort.rash"))
      end
      it 'returns nil if no cache' do
        config.cache_folder = nil
        config.cache_file_for(source).should be_nil
      end
      it 'works with a benchmark' do
        config = fixtures_config
        source = Benchmark.new(config.benchmark_folder/"bench_iteration.rb")
        config.cache_file_for(source).should eq(config.cache_folder/'bench_iteration.rash')
      end
    end

  end
end