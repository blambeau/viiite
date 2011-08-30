require 'fileutils'
require 'viiite/bdb/utils'
require 'viiite/bdb/immediate'
require 'viiite/bdb/cached'
module Viiite
  class BDB
    include Utils

    DEFAULT_OPTIONS = {
      :folder       => "benchmarks",
      :cache        => true,
      :cache_mode   => "w",
      :pattern      => "bench_*.rb",
      :ext          => ".rb",
    }

    def self.new(options = {})
      options = DEFAULT_OPTIONS.merge(options)
      folder = options[:folder]
      bdb = BDB::Immediate.new(folder, options)
      if cache = options[:cache]
        cache = File.join(folder, '.cache') unless cache.is_a?(String)
        mode  = options[:cache_mode]
        bdb   = BDB::Cached.new(bdb, cache, mode)
      end
      bdb
    end

  end # class BDB
end # module Viiite
