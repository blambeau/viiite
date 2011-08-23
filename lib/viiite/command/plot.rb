module Viiite
  class Command < Quickl::Delegator(__FILE__, __LINE__)
    # 
    # Report benchmarking results as a plot
    #
    # SYNOPSIS
    #   viiite #{command_name} [BENCHFILE]
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Plot < Quickl::Command(__FILE__, __LINE__)
      include Commons 

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
        
        @serie_style = File.expand_path("../serie_style.rash", __FILE__)
        opt.on('--style=FILE', "Specify a style file to use for series") do |value|
          @serie_style = value
        end
        
        @graph_style = File.expand_path("../graph_style.rash", __FILE__)
        opt.on('--style=FILE', "Specify a style file to use for graphs") do |value|
          @graph_style = value
        end
        
        @abscissa = :size
        opt.on('-x abscissa', "Specify the abscissa attribute") do |value|
          @abscissa = value.to_sym
        end
        
        @ordinate = "tms.total"
        opt.on('-y ordinate', "Specify the ordinate attribute") do |value|
          @ordinate = value
        end

        @series = :bench
        opt.on("--series=ATTR",
               "Specify the attribute to split series") do |value|
          @series = value.to_sym
        end

        @graph = :ruby
        opt.on('--graph=ATTR', 
               "Specify the attribute to split graphs") do |value|
          @graph = value.to_sym
        end
      end
    
      def query(op)
        lispy = Alf.lispy
        op = lispy.summarize(op, [@graph, @series, @abscissa].compact, 
                                 {:y => "avg{ #{@ordinate} }"})
        op = lispy.join(op, Alf::Reader.reader(@serie_style))
        op = lispy.rename(op, @graph  => :graph, @abscissa => :x, @series => :serie)
        op = lispy.group(op, [:x, :y], :data)
        op = lispy.rename(op, :serie => :title)
        op = lispy.group(op, [:graph], :series, {:allbut => true})
        op = lispy.join(op, Alf::Reader.reader(@graph_style))
        op = lispy.rename(op, :graph => :title)
        op
      end
      
      def execute(argv)
        op = single_source(argv) do |bdb, arg|
          bdb.dataset(arg)
        end
        op = query(op)
        case @render
        when :text
          Alf::Renderer.text(op).execute($stdout)
        when :gnuplot
          $stdout << "set terminal #{@term}\n"
          Viiite::Formatter::Plot::to_plots(op.to_a, $stdout)
        end
      end
    
    end # class Plot
  end # class Command
end # module Viiite
