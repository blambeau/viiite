$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'viiite'
require 'stringio'

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
  EPath.new(__FILE__).parent/'fixtures'
end
