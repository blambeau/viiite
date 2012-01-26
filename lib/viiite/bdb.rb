require 'fileutils'
require 'viiite/bdb/utils'
require 'viiite/bdb/immediate'
require 'viiite/bdb/cached'
module Viiite
  class BDB
    include Utils

    def self.new(config)
      bdb = BDB::Immediate.new(config)
      if config.cache_enabled?
        bdb = BDB::Cached.new(bdb)
      end
      bdb
    end

  end # class BDB
end # module Viiite
