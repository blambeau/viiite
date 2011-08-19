module Bench
  #
  # bench - Benchmark ruby scripts the easy way
  #
  # SYNOPSIS
  #   #{program_name} [--version] [--help] COMMAND [cmd opts] ARGS...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # COMMANDS
  # #{summarized_subcommands}
  #
  # DESCRIPTION
  #   This command helps you benchmarking ruby applications and manipulating
  #   benchmark results very simply.
  #
  # See '#{program_name} help COMMAND' for more information on a specific command.
  #
  class Command < Quickl::Delegator(__FILE__, __LINE__)
  
    # 
    # Show help about a specific command
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} COMMAND
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

    # 
    # Run a benchmark 
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [BENCHFILE]
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Run < Quickl::Command(__FILE__, __LINE__)
      
      def execute(args)
        raise Quickl::InvalidArgument if args.size > 1
        input  = Alf::Reader.reader(args.first || $stdin)
        output = $stdout
        Alf::Renderer.rash(input).execute(output)
      end

    end # class Run

    # 
    # Show a benchmark 
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [BENCHFILE]
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Show < Quickl::Command(__FILE__, __LINE__)

      options do |opt|
        @by = nil
        opt.on("--by=x,y,z", Array, 
               "Specify the aggregation 'by key'") do |by|
          @by = by
        end
        opt.on("--rg=x,y,z", Array,
               "Regroup by x, then y, then z, ...") do |group|
          @by = ((@by || []) + group).uniq
          @regroup = group
        end
      end

      def query(input)
        lispy = Alf.lispy
        op = input
        op = lispy.summarize(op, @by || [:bench_case], :time => lispy.avg{tms})
        if @regroup
          op = lispy.group(op, @regroup, :bench_cases, {:allbut => true})
        end
      end

      def execute(args)
        case args
        when Array
          raise Quickl::InvalidArgument if args.size > 1
          execute Alf::Reader.reader(args.first || $stdin)
        when Alf::Iterator
          Alf::Renderer.text(query(args)).execute($stdout)
        else 
          raise ArgumentError, "Unable to show #{args.inspec}"
        end
      end

    end # class Show

    # 
    # Generates a plot
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [BENCHFILE]
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Plot < Quickl::Command(__FILE__, __LINE__)
    
      # Install options
      options do |opt|
        @render = :text
        opt.on('--text', "Render output as a text table") do
          @render = :text
        end

        opt.on("--gnuplot=[TERM]", 
               "Render output as a gnuplot text (and terminal)") do |value|
          @render = :gnuplot
          @term = (value || "dumb").to_sym
        end
        
        opt.on('--style=FILE', "Joins a graph style file") do |value|
          @style = value
        end
        
        @graph = nil
        opt.on('-g graph', "Specify multi-graph attribute") do |value|
          @graph = value.to_sym
        end
        
        @abscissa = :x
        opt.on('-x abscissa', "Specify abscissa attribute") do |value|
          @abscissa = value.to_sym
        end
        
        @ordinate = :y
        opt.on('-y ordinate', "Specify ordinate attribute") do |value|
          @ordinate = value.to_sym
        end
        
        @series = :series
        opt.on('-s series', "Specify series attribute") do |value|
          @series = value.to_sym
        end
      end
    
      def query(op)
        lispy = Alf.lispy
        op = lispy.project(op, [@graph, @abscissa, @ordinate, @series])
        op = lispy.join(op, Alf::Reader.reader(@style)) if @style
        op = lispy.rename(op, @graph => :graph, @abscissa => :x, @ordinate => :y, 
                              @series => :serie)
        op = lispy.summarize(op, [:y], {:y => lispy.avg(:y)}, {:allbut => true})
        op = lispy.group(op, [:x, :y], :data)
        op = lispy.rename(op, :serie => :title)
        op = lispy.group(op, [:graph], :series, {:allbut => true})
        op = lispy.rename(op, :graph => :title)
      end
      
      def execute(args)
        raise Quickl::InvalidArgument if args.size > 1
        op = query Alf::Reader.reader(args.first || $stdin)
        case @render
        when :text
          Alf::Renderer.text(op).execute($stdout)
        when :gnuplot
          $stdout << "set terminal #{@term}\n"
          Bench::Formatter::Plot::to_plots(op.to_a, $stdout)
        end
      end
    
    end # class Plot

    # Install options
    options do |opt|
      opt.on("-Idirectory", 
             "specify $LOAD_PATH directory (may be used more than once)") do |val|
        $LOAD_PATH.unshift val
      end
      opt.on('-rlibrary',
             "require the library, before executing bench") do |lib|
        require(lib)
      end
      opt.on_tail("--help", "Show help") do
        raise Quickl::Help
      end
      opt.on_tail("--version", "Show version") do
        raise Quickl::Exit, "#{program_name} #{Bench::VERSION} (c) 2011, Bernard Lambeau"
      end
    end
    
  end # class Command
end # module Bench
