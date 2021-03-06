require 'spec_helper'
describe "viiite commands", :ruby => 1.9 do

  Path.dir.glob('**/*.cmd').each do |input|
    cmd = input.read.chomp

    specify "#{input.base}: #{cmd}" do
      argv = Quickl.parse_commandline_args(cmd)[1..-1]
      stdout = input.sub_ext('.stdout')
      stderr = input.sub_ext('.stderr')
      stdout_expected = stdout.exist? ? stdout.read : ""
      stderr_expected = stderr.exist? ? stderr.read : ""

      cmd.should match /^viiite /
      cache = fixtures_folder/'saved'
      out, err = capture_io do
        begin
          Viiite::Command.run(["--suite=#{fixtures_folder}/bdb", "--cache=#{cache}"] + argv)
        rescue SystemExit
          puts "SystemExit"
        end
      end

      out.should eq stdout_expected
      err.should eq stderr_expected
    end
  end

end
