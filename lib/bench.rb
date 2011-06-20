require "bench/version"
require "bench/loader"
require "benchmark"
#
# Benchmarking and complexity analyzer utility
#
module Bench

  def self.runner(&block)
    Runner.new(block)
  end

  def self.short_ruby_descr
    if Object.const_defined?(:RUBY_DESCRIPTION)
      RUBY_DESCRIPTION =~ /^([^\s]+\s*[^\s]+)/
      $1
    else
      "ruby #{RUBY_VERSION} (#{RUBY_PLATFORM})"
    end
  end
    
end # module Bench
require "bench/runner"
require "bench/formatter/plot"
