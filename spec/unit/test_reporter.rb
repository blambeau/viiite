# require 'spec_helper'
# module Viiite
#   describe Reporter do
# 
#     let(:config) { fixtures_config                    }
#     let(:io)     { config.stdout                      }
#     let(:subject){ Reporter::new(config)              }
#     let(:tuple)  { {:ruby => "rules the world"}       }
#     let(:literal){ %Q|{:ruby => "rules the world"}\n| }
# 
#     let(:bench){
#       Benchmark.new(config.benchmark_folder/'bench_iteration.rb')
#     }
#     let(:suite){
#       Suite.new(config, config.benchmark_folder/'bench_iteration.rb')
#     }
# 
#     it 'outputs hash literals when called' do
#       subject.call(tuple)
#       io.string.should eq(literal)
#     end
# 
#     context "without cache" do
#       before{ config.cache_folder = nil }
#       it 'reports without error on a benchmark' do
#         subject.report(bench)
#         io.string.should_not be_empty
#       end
#       it 'reports without error on a suite' do
#         subject.report(bench)
#         io.string.should_not be_empty
#       end
#     end
# 
#     context 'with a cache folder' do
#       let(:cache){ Path.dir/'acachefolder' }
#       before{ 
#         config.cache_folder = cache 
#         config.cache_folder.rm_rf
#         config.cache_folder.mkdir_p
#       }
#       after{ 
#         config.cache_folder.rm_rf
#       }
#       it 'reports without error on a benchmark' do
#         subject.report(bench)
#         io.string.should_not be_empty
#         (config.cache_folder/"bench_iteration.rash").should be_exist
#       end
#     end
# 
#   end # describe Reporter
# end # module Viiite