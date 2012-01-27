$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'viiite'
require 'stringio'
require File.expand_path('../unit/shared/unit', __FILE__)

RSpec.configure do |c|
  c.filter_run_excluding :ruby => lambda { |version| RUBY_VERSION < version.to_s }
end

def capture_io
  stdout, stderr = $stdout, $stderr
  $stdout, $stderr = StringIO.new, StringIO.new
  yield
  [$stdout.string, $stderr.string]
ensure
  $stdout, $stderr = stdout, stderr
end

def fixtures_folder
  Path.dir/'fixtures'
end

def fixtures_config
  Viiite::Configuration.new do |c|
    c.benchmark_folder  = Path.dir/:fixtures/:bdb
    c.cache_folder      = Path.dir/:fixtures/:saved
    c.benchmark_pattern = "**/*.rb"
    c.pwd               = Path.dir/:fixtures/:bdb
    c.stdout            = StringIO.new
  end
end

