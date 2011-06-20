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

  def self.summarizer(&block)
    Summarizer.new(block)
  end

  def self.sortkeys(keys)
    keys.sort{|k1,k2|
      k1.respond_to?(:<=>) ? k1 <=> k2 : k1.to_s <=> k2.to_s
    }
  end

  def self.render(rel)
    Formatter::Text.render(rel)
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
require "bench/inputter/hash_reader"
require "bench/formatter/plot"
