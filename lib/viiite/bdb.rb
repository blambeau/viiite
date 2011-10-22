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
      folder, cache = Path(options[:folder]), options[:cache]

      bdb = BDB::Immediate.new(folder, options[:pattern])

      if cache
        # true cache heuristics -> default cache folder
        cache = folder/'.cache' if cache == true
        bdb = BDB::Cached.new(bdb, Path(cache))
      end

      bdb
    end

  end # class BDB
end # module Viiite
