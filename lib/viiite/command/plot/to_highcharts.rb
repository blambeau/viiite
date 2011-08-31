module Viiite
  class Command
    class Plot

      options do |opt|
        opt.on("--highcharts=[TERM]",
               "Render output for highcharts.js") do |value|
          @render = :highcharts
          @highcharts_term = (value || "json").to_sym
          @graph_style = load_style("to_highcharts_graph.rb", __FILE__) unless @graph_style
        end
      end

      def to_highcharts_query(lispy, op)
        lispy = Alf.lispy
        op = lispy.summarize(op, [@graph, @series, @abscissa].compact,
                                 {:y => "avg{ #{@ordinate} }"})
        op = lispy.rename(op, @graph  => :graph, @abscissa => :x, @series => :serie)
        op = lispy.summarize(op,
                             [:x, :y],
                             {:data => lispy.collect{ [x, y] }},
                             {:allbut => true})
        op = lispy.rename(op, :serie => :name)
        op = lispy.group(op, [:name, :data], :series)
        op = lispy.join(op, @graph_style) if @graph_style
        op = lispy.extend(op, :title => lambda{ title.merge(:text => graph) })
        op = lispy.project(op, [:graph], {:allbut => true})
        op
      end

      def to_highcharts(lispy, op)
        require 'json'
        $stdout << op.to_a.to_json << "\n"
      end

    end # class Plot
  end # class Command
end # module Viiite
