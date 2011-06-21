task :clean do
  Dir["**/*.rbc"].each{|f| FileUtils.rm_rf(f)}
end