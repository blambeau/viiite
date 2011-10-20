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
      :pattern      => "**/*.rb",
    }

    def self.new(options = {})
      options = DEFAULT_OPTIONS.merge(options)
      folder, cache = options.values_at :folder, :cache

      bdb = BDB::Immediate.new(folder, options[:pattern])

      # true cache heuristics -> default cache folder
      cache = File.join(folder, '.cache') if cache == true

      # Build a cache if requested
      bdb = BDB::Cached.new(bdb, cache) if cache

      bdb
    end

  end # class BDB
end # module Viiite
