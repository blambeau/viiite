module Bench
  module Version
  
    MAJOR = 0
    MINOR = 0
    TINY  = 1
  
    def self.to_s
      [ MAJOR, MINOR, TINY ].join('.')
    end
  
  end 
  VERSION = Version.to_s
end
