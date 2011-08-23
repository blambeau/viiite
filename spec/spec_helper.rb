$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'viiite'

def redirect_io
  $oldstdout = $stdout 
  $oldstderr = $stderr
  $stdout = StringIO.new
  $stderr = StringIO.new
  [$stdout, $stderr]
end

def restore_io
  $stdout = $oldstdout
  $stderr = $oldstderr
  $oldstdout = nil 
  $oldstderr = nil 
end

def fixtures_folder
  File.expand_path('../fixtures', __FILE__)
end

