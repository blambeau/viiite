require 'spec_helper'
describe "viiite commands" do

  Dir[File.expand_path('../**/*.cmd', __FILE__)].each do |input|
    input = EPath.new(input)
    cmd = input.read.chomp

    specify "#{File.basename(input)}: #{cmd}" do
      argv = Quickl.parse_commandline_args(cmd)[1..-1]
      stdout = input.replace_extension('.stdout')
      stderr = input.replace_extension('.stderr')
      stdout_expected = stdout.exist? ? stdout.read : ""
      stderr_expected = stderr.exist? ? stderr.read : ""

      cmd.should match /^viiite /
      cache = File.join(fixtures_folder, "saved")
      out, err = capture_io do
        begin
          Viiite::Command.run(["--suite=#{fixtures_folder}/bdb", "--cache=#{cache}"] + argv)
        rescue SystemExit
          puts "SystemExit"
        end
      end

      out.should eq stdout_expected unless RUBY_VERSION < "1.9"
      err.should eq stderr_expected unless RUBY_VERSION < "1.9"
    end
  end

end
