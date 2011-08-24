module Viiite
  class Command
    class Plot

      options do |opt|
        @render = :text
        opt.on('--text', "Render output as a text table") do
          @render = :text
        end
      end

      def to_text_query(lispy, op)
        lispy = Alf.lispy
        op = lispy.summarize(op, [@graph, @series, @abscissa].compact, 
                                 {:y => "avg{ #{@ordinate} }"})
        op = lispy.rename(op, @graph  => :graph, @abscissa => :x, @series => :serie)
        op = lispy.group(op, [:x, :y], :data)
        op = lispy.rename(op, :serie => :title)
        op = lispy.group(op, [:graph], :series, {:allbut => true})
        op = lispy.rename(op, :graph => :title)
        op
      end

      def to_text(lispy, op)
        Alf::Renderer.text(op).execute($stdout)
      end

    end # class Plot
  end # class Command
end # module Viiite
