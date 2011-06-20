module Bench
  class Command
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
      include Alf::Lispy
    
      # Install options
      options do |opt|
        @render = :text
        opt.on('--text', "Render output as a text table") do
          @render = :text
        end
        opt.on('--gplot', "Render output as a gnuplot input text") do
          @render = :gplot
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
    
      def query(input)
        (group \
          (group \
            (summarize \
              (rename input, @abscissa => :x, @ordinate => :y, @series => :title),
              [:title, :x], 
              :y => Agg::avg(:y)),
            [:x, :y], :data),
          [:title, :data], :datasets)
      end
      
      def execute(args)
        raise Quickl::InvalidArgument if args.size > 1
        input = if args.empty?
          $stdin
        else
          arg = args.first
          Kernel.instance_eval(File.read(arg), arg)
        end
        op = query(input)
        case @render
        when :text
          Alf::Renderer.text(op).execute($stdout)
        when :gplot
          puts Bench::Formatter::Plot::to_plot(op.to_a.first).to_gplot
        end
      end
    
    end # class Plot
  end # class Command
end # module Bench