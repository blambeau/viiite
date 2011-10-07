begin
  require "alf"
  require "gnuplot"
  require "json"
  require "epath"
rescue LoadError
  require 'rubygems'
  retry
end
