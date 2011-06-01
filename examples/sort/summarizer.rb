#!/usr/bin/env bench
Bench.summarizer do |s|
  s.pivot :test
  s.by    :size
  s.avg   :real => :time
end
