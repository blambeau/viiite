module Bench
  class Command < Quickl::Delegator(__FILE__, __LINE__)
    # 
    # Report benchmarking results as a plot
    #
    # SYNOPSIS
    #   bench #{command_name} [BENCHFILE]
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
  end # class Command
end # module Bench
