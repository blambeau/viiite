begin
  gem "bundler", "~> 1.0"
  require "bundler/setup"
rescue LoadError => ex
  puts ex.message
  abort "Bundler failed to load, (did you run 'gem install bundler' ?)"
end

# Dynamically load the gem spec
$gemspec_file = File.expand_path('../viiite.gemspec', __FILE__)
$gemspec      = Kernel.eval(File.read($gemspec_file))

# We run tests by default
task :default => :test

#
# Install all tasks found in tasks folder
#
# See .rake files there for complete documentation.
#
Dir["tasks/**/*.rake"].each do |taskfile|
  instance_eval File.read(taskfile), taskfile
end
