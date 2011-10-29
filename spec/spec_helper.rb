$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'viiite'
require 'stringio'

RSpec.configure do |c|
  c.filter_run_excluding :ruby => lambda { |version| RUBY_VERSION < version.to_s }
end

def capture_io
  stdout, stderr = $stdout, $stderr
  out, err = StringIO.new, StringIO.new
  $stdout, $stderr = out, err
  yield
  [out.string, err.string]
ensure
  $stdout, $stderr = stdout, stderr
end

def fixtures_folder
  Path.dir/'fixtures'
end
