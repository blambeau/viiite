begin
  require "rspec/core/rake_task"
  desc "Run RSpec code examples"
  RSpec::Core::RakeTask.new(:integration_test) do |t|
    # Glob pattern to match files.
    t.pattern = "spec/integration/**/test_*.rb"

    # By default, if there is a Gemfile, the generated command will include
    # 'bundle exec'. Set this to true to ignore the presence of a Gemfile,
    # and not add 'bundle exec' to the command.
    t.skip_bundler = false

    # Name of Gemfile to use
    t.gemfile = "Gemfile"

    # Whether or not to fail Rake when an error occurs (typically when
    # examples fail).
    t.fail_on_error = true

    # A message to print to stderr when there are failures.
    t.failure_message = nil

    # Use verbose output. If this is set to true, the task will print the
    # executed spec command to stdout.
    t.verbose = true

    # Use rcov for code coverage?
    t.rcov = false

    # Path to rcov.
    t.rcov_path = "rcov"

    # Command line options to pass to rcov. See 'rcov --help' about this
    t.rcov_opts = []

    # Command line options to pass to ruby. See 'ruby --help' about this
    t.ruby_opts = []

    # Path to rspec
    t.rspec_path = "rspec"

    # Command line options to pass to rspec. See 'rspec --help' about this
    t.rspec_opts = ["--color", "--backtrace"]
  end
rescue LoadError => ex
  task :integration_test do
    abort 'rspec is not available. In order to run spec, you must: gem install rspec'
  end
ensure
  task :test => [:integration_test]
end
