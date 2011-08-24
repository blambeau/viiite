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

        @serie_style = File.expand_path("../serie_style.rash", __FILE__)
        opt.on('--serie-style=FILE', "Specify a style file to use for series") do |value|
          @serie_style = value
        end
        
        @graph_style = File.expand_path("../graph_style.rash", __FILE__)
        opt.on('--graph-style=FILE', "Specify a style file to use for graphs") do |value|
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

        @debug = false
        opt.on('-d', 
               'Print the query result instead of rendering') do
          @debug = true
        end
      end
    
      def execute(argv)
        lispy = Alf.lispy
        op = single_source(argv) do |bdb, arg|
          bdb.dataset(arg)
        end
        op = send(:"to_#{@render}_query", lispy, op)
        if @debug
          Alf::Renderer.text(op).execute($stdout)
        else
          send(:"to_#{@render}", lispy, op)
        end
      end
    
    end # class Plot
  end # class Command
end # module Viiite
require 'viiite/command/plot/to_text'
require 'viiite/command/plot/to_gnuplot'
require 'viiite/command/plot/to_highcharts'
