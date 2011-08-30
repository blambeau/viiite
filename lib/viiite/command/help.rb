module Viiite
  class Command
    #
    # Show help about a specific command
    #
    # SYNOPSIS
    #   viiite #{command_name} COMMAND
    #
    class Help < Quickl::Command(__FILE__, __LINE__)

      # Let NoSuchCommandError be passed to higher stage
      no_react_to Quickl::NoSuchCommand

      # Command execution
      def execute(args)
        sup = Quickl.super_command(self)
        sub = (args.size != 1) ? sup : Quickl.sub_command!(sup, args.first)
        puts Quickl.help(sub)
      end

    end # class Help
  end # class Command
end # module Viiite

