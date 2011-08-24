module Viiite
  class Command
    class Plot

      options do |opt|
        opt.on("--gnuplot=[TERM]", 
               "Render output as a gnuplot text (and terminal)") do |value|
          @render = :gnuplot
          @gnuplot_term = (value || "dumb").to_sym
        end
      end

      def to_gnuplot_query(lispy, op)
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

      def to_gnuplot(lispy, op)
        op = to_gnuplot_query(lispy, op)
        $stdout << "set terminal #{@gnuplot_term}\n"
        Viiite::Formatter::Plot::to_plots(op.to_a, $stdout)
      end

    end # class Plot
  end # class Command
end # module Viiite
