begin
  require "alf"
  require "gnuplot"
  require "json"
rescue LoadError
  require 'rubygems'
  retry
end
