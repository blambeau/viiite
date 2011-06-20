begin
  require "gnuplot"
rescue LoadError
  require "rubygems"
  require "gnuplot"
end 
module Bench
  class Formatter
    class Plot < Formatter

      def self.to_data(rel)
        [rel.collect{|t| t[:x]}, rel.collect{|t| t[:y]}]
      end

      def self.to_dataset(tuple)
        ds = Gnuplot::DataSet.new(to_data(tuple[:data]))
        ds.with = "linespoints"
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
            next if k == :datasets
            plot.set(k.id2name, v)
          end
          plot.data = graph[:datasets].collect{|d| to_dataset(d)}
        end
      end

      def self.render(graph)
        Gnuplot.open do |gp|
          gp << to_plot(graph).to_gplot
        end
      end

    end # class Plot
  end # class Formatter
end # module Bench
