desc "Start a server to browse the benchmarks"
task "bench:browse" do
  require 'viiite/browser'
  Viiite::Browser::App.run!
end
