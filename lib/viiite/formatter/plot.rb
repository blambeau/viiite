module Viiite
  class Formatter
    class Plot < Formatter

      def self.to_data(rel)
        [rel.collect{|t| t[:x]}, rel.collect{|t| t[:y]}]
      end

      def self.to_dataset(tuple)
        ds = Gnuplot::DataSet.new(to_data(tuple[:data]))
        tuple.each_pair do |k,v|
          next if k == :data
          if ds.respond_to?(:"#{k}=")
            ds.send(:"#{k}=", v)
          end 
        end
        ds
      end

      def self.to_plot(graph)
        Gnuplot::Plot.new do |plot|
          graph.each_pair do |k,v|
            next if k == :series
            plot.set(k.id2name, v)
          end
          plot.data = graph[:series].collect{|d| to_dataset(d)}
        end
      end

      def self.to_plots(graphs, buffer = "")
        graphs.each do |tuple|
          buffer << to_plot(tuple).to_gplot << "\n"
        end
      end

    end # class Plot
  end # class Formatter
end # module Viiite
