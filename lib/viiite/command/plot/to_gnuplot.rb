module Viiite
  class Command
    class Plot

      options do |opt|
        opt.on("--gnuplot=[TERM]",
               "Render output as a gnuplot text (and terminal)") do |value|
          @render = :gnuplot
          @gnuplot_term = (value || "dumb").to_sym
          @graph_style = load_style(Path.dir/'to_gnuplot_graph.rash') unless @graph_style
          @serie_style = load_style(Path.dir/'to_gnuplot_serie.rash') unless @serie_style
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
        puts "set terminal #{@gnuplot_term}"
        GnuplotUtils.to_plots(op.to_a, $stdout)
      end

      module GnuplotUtils
        extend self
        def to_data(rel)
          [rel.collect{|t| t[:x]}, rel.collect{|t| t[:y]}]
        end
        def to_dataset(tuple)
          ds = Gnuplot::DataSet.new(to_data(tuple[:data]))
          tuple.each_pair do |k,v|
            next if k == :data
            ds.send(:"#{k}=", v) if ds.respond_to?(:"#{k}=")
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
      end # module Utils

    end # class Plot
  end # class Command
end # module Viiite
