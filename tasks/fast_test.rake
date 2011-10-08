desc "Run all tests, faster"
task :fast_test do
  require 'rspec'
  integration_tests = Dir["spec/integration/**/test_*.rb"]
  spec_tests = Dir["spec/unit/**/test_*.rb"]
  RSpec::Core::Runner.run(%w[--color] + integration_tests + spec_tests)
end
