require 'spec_helper'
describe "bench command / " do

  Dir[File.expand_path('../**/*.cmd', __FILE__)].each do |input|
    cmd = File.readlines(input).first
    specify{ cmd.should =~ /^bench / }
  
    describe "#{File.basename(input)}: #{cmd}" do
      let(:argv)     { Quickl.parse_commandline_args(cmd)[1..-1] }
      let(:stdout)   { File.join(File.dirname(input), "#{File.basename(input, ".cmd")}.stdout") }
      let(:stderr)   { File.join(File.dirname(input), "#{File.basename(input, ".cmd")}.stderr") }
      let(:stdout_expected) { File.exists?(stdout) ? File.read(stdout) : "" }
      let(:stderr_expected) { File.exists?(stderr) ? File.read(stderr) : "" }

      before{ 
        $oldstdout = $stdout 
        $oldstderr = $stderr
        $stdout = StringIO.new
        $stderr = StringIO.new
      }
      after { 
        $stdout = $oldstdout
        $stderr = $oldstderr
        $oldstdout = nil 
        $oldstderr = nil 
      }
      
      specify{
        begin
          Bench::Command.run(argv)
        rescue SystemExit
          $stdout << "SystemExit" << "\n"
        end
        $stdout.string.should(eq(stdout_expected)) unless RUBY_VERSION < "1.9"
        $stderr.string.should(eq(stderr_expected)) unless RUBY_VERSION < "1.9"
      }
    end
  end
    
end
