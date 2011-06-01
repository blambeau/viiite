begin
  require "quickl"
rescue LoadError
  require "rubygems"
  require "quickl"
end 
begin
  require "gnuplot"
rescue LoadError
  require "rubygems"
  require "gnuplot"
end 

