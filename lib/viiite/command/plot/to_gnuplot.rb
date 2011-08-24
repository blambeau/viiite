module Viiite
  class Command
    class Plot

      options do |opt|
        opt.on("--gnuplot=[TERM]", 
               "Render output as a gnuplot text (and terminal)") do |value|
          @render = :gnuplot
          @gnuplot_term = (value || "dumb").to_sym
          @graph_style = load_style("to_gnuplot_graph.rash", __FILE__) unless @graph_style
          @serie_style = load_style("to_gnuplot_serie.rash", __FILE__) unless @serie_style
        end
      end

      def to_gnuplot_query(lispy, op)
        lispy = Alf.lispy
        op = lispy.summarize(op, [@graph, @series, @abscissa].compact, 
                                 {:y => "avg{ #{@ordinate} }"})
        op = lispy.join(op, @serie_style) if @serie_style
        op = lispy.rename(op, @graph  => :graph, @abscissa => :x, @series => :serie)
        op = lispy.group(op, [:x, :y], :data)
        op = lispy.rename(op, :serie => :title)
        op = lispy.group(op, [:graph], :series, {:allbut => true})
        op = lispy.join(op, @graph_style) if @graph_style
        op = lispy.rename(op, :graph => :title)
        op
      end

      def to_gnuplot(lispy, op)
        $stdout << "set terminal #{@gnuplot_term}\n"
        GnuplotUtils.to_plots(op.to_a, $stdout)
      end

      module GnuplotUtils
        def to_data(rel)
          [rel.collect{|t| t[:x]}, rel.collect{|t| t[:y]}]
        end
        def to_dataset(tuple)
          ds = Gnuplot::DataSet.new(to_data(tuple[:data]))
          tuple.each_pair do |k,v|
            next if k == :data
            if ds.respond_to?(:"#{k}=")
              ds.send(:"#{k}=", v)
            end 
          end
          ds
        end
        def to_plot(graph)
          Gnuplot::Plot.new do |plot|
            graph.each_pair do |k,v|
              next if k == :series
              plot.set(k.id2name, v)
            end
            plot.data = graph[:series].collect{|d| to_dataset(d)}
          end
        end
        def to_plots(graphs, buffer = "")
          graphs.each do |tuple|
            buffer << to_plot(tuple).to_gplot << "\n"
          end
        end
        extend self
      end # module Utils

    end # class Plot
  end # class Command
end # module Viiite
