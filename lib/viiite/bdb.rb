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

    def self.cached(folder = "benchmarks", 
                    cache_folder = File.join(folder, '.cache'))
      BDB::Cached.new(immediate(folder), cache_folder)
    end

  end # class BDB
end # module Viiite
