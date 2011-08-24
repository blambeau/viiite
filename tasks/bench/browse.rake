task :"bench:browse" do
  require 'viiite/browser'
  Viiite::Browser::App.run!
end
