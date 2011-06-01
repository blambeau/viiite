module Bench
  class Command
    # 
    # Run a benchmark 
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} BENCHFILE
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Run < Quickl::Command(__FILE__, __LINE__)
      
      options do |opt|
        
        @formatter = :text
        opt.on('-p', '--pipe') do 
          @formatter = :inspect
        end

      end # options

      def output(enum, io = $stdout)
        case @formatter
          when :inspect
            enum.each{|t| io << t.inspect << "\n"}
          when :text
            Formatter::Text.render(enum, io)
        end
      end

      def build_chain(args)
        parts = args.collect do |arg|
          Kernel.instance_eval(File.read(arg), arg)
        end
        parts.unshift Inputter::HashReader.new($stdin)
        parts[1..-1].inject(parts.first) do |chain, n|
          n.pipe(chain)
        end
      end

      def execute(args)
        chain = build_chain(args)
        output(chain)
      end

    end # class Help
  end # class Command
end # module Bench
