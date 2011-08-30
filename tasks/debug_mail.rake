# Installs a rake task for debuging the announcement mail.
#
# This file installs the 'rake debug_mail' that flushes an announcement mail
# for your library on the standard output. It is automatically generated
# by Noe from your .noespec file, and should therefore be configured there,
# under the variables/rake_tasks/debug_mail entry, as illustrated below:
#
# variables:
#   rake_tasks:
#     debug_mail:
#       rx_changelog_sections: /^#/
#       nb_changelog_sections: 1
#       ...
#
# If you have specific needs requiring manual intervention on this file,
# don't forget to set safe-override to false in your noe specification:
#
# template-info:
#   manifest:
#     tasks/debug_mail.rake:
#       safe-override: false
#
# The mail template used can be found in debug_mail.txt. That file may be
# changed to tune the mail you want to send. If you do so, don't forget to
# add a manifest entry in your .noespec file to avoid overriding you
# changes. The mail template uses wlang, with parentheses for block
# delimiters.
#
# template-info:
#   manifest:
#     tasks/debug_mail.txt:
#       safe-override: false
#
begin
  require 'wlang'
  require 'yaml'

  desc "Debug the release announcement mail"
  task :debug_mail do
    # Check that a .noespec file exists
    noespec_file = File.expand_path('../../viiite.noespec', __FILE__)
    unless File.exists?(noespec_file)
      raise "Unable to find .noespec project file, sorry."
    end

    # Load it as well as variables and options
    noespec = YAML::load(File.read(noespec_file))
    vars = noespec['variables'] || {}

    # Changes are taken from CHANGELOG
    logs = Dir[File.expand_path("../../CHANGELOG.*", __FILE__)]
    unless logs.size == 1
      abort "Unable to find a changelog file"
    end

    # Load interesting changesets
    changes, end_found = [], 0
    File.readlines(logs.first).select{|line|
      if line =~ /^# /
        break if end_found >= 1
        end_found += 1
      end
      changes << line
    }
    vars['changes'] = changes.join

    # WLang template
    template = File.expand_path('../debug_mail.txt', __FILE__)

    # Let's go!
    $stdout << WLang::file_instantiate(template, vars, "wlang/active-text")
  end

rescue LoadError
  task :debug_mail do
    abort "wlang is not available. Try 'gem install wlang'"
  end
end
