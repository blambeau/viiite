Bench::Summarizer.new{|s|
  s.by    :ruby_version
  s.pivot :test
  s.by    :runs
  s.avg   :real => :avg
  s.max   :real => :max
  s.min   :real => :min
}
