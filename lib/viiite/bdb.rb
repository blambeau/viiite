require 'fileutils'
require 'viiite/bdb/utils'
require 'viiite/bdb/immediate'
require 'viiite/bdb/cached'
module Viiite
  class BDB
    include Utils

    def self.immediate(folder = "benchmarks")
      BDB::Immediate.new(folder)
    end

    def self.cached(folder = "benchmarks", cache = nil)
      if folder.is_a?(BDB)
        bdb = folder
        cache ||= File.join(folder.folder, '.cache')
      else
        bdb = immediate(folder)
        cache ||= File.join(folder, '.cache')
      end
      BDB::Cached.new(bdb, cache)
    end

  end # class BDB
end # module Viiite
