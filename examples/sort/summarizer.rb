Bench.summarizer do |s|
  s.by :ruby_version
  s.pivot :test
  s.by    :size
  s.avg   :real => :time
end
