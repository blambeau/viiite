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

def bench_iteration
  File.expand_path('../fixtures/bench_iteration.rb', __FILE__)
end


