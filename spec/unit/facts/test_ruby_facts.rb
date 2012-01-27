require 'spec_helper'
module Viiite
  describe RubyFacts do
    include RubyFacts

    it 'short_ruby_description' do
      {
        'ruby 1.8.7 (2011-02-18 patchlevel 334) [x86_64-linux]' => 'ruby 1.8.7p334',
        'ruby 1.8.7 (2011-06-30 patchlevel 352) [x86_64-linux]' => 'ruby 1.8.7p352',
        'ruby 1.8.7 (2011-02-18 patchlevel 334) [x86_64-linux], MBARI 0x6770, Ruby Enterprise Edition 2011.03' => 'ree 2011.03',
        'ruby 1.9.2p290 (2011-07-09 revision 32553) [x86_64-linux]' => 'ruby 1.9.2p290',
        'ruby 1.9.3dev (2011-07-31 revision 32789) [x86_64-linux]' => 'ruby 1.9.3dev',
        'ruby 1.9.4dev (2011-08-24 trunk 33047) [x86_64-linux]' => 'ruby 1.9.4dev',
        'rubinius 1.2.5dev (1.8.7 489d5384 yyyy-mm-dd JI) [x86_64-unknown-linux-gnu]' => 'rubinius 1.2.5dev',
        'rubinius 2.0.0dev (1.8.7 d705d318 yyyy-mm-dd JI) [x86_64-unknown-linux-gnu]' => 'rubinius 2.0.0dev',
        'jruby 1.6.3 (ruby-1.8.7-p330) (2011-07-07 965162f) (OpenJDK 64-Bit Server VM 1.6.0_22) [linux-amd64-java]' => 'jruby 1.6.3',
        'jruby 1.7.0.dev (ruby-1.8.7-p330) (2011-08-24 7b9f999) (OpenJDK 64-Bit Server VM 1.6.0_22) [linux-amd64-java]' => 'jruby 1.7.0.dev',
      }.each_pair { |description, short|
        short_ruby_description(description).should == short
      }
    end
    
    it 'which' do
      which.should_not be_nil
    end
    
    it 'has public methods installed on the module itself' do
      RubyFacts.should respond_to(:which)
    end

  end
end