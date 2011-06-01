module Bench
  class Formatter
    class Text < Formatter

      module Utils

        def looks_a_relation?(value)
          value.is_a?(Array) && !value.empty? && value.all?{|v| v.is_a?(Hash)}
        end

        def max(x, y)
          return y if x.nil?
          return x if y.nil?
          x > y ? x : y
        end

      end
      include Utils

      class Cell
        include Utils

        def initialize(value)
          @value = value
        end

        def min_width
          @min_width ||= rendering_lines.inject(0) do |maxl,line|
            max(maxl,line.size)
          end
        end

        def rendering_lines(size = nil)
          if size.nil?
            text_rendering.split(/\n/)
          elsif @value.is_a?(Numeric)
            rendering_lines(nil).collect{|l| "%#{size}s" % l}
          else
            rendering_lines(nil).collect{|l| "%-#{size}s" % l}
          end
        end

        def text_rendering
          @text_rendering ||= case (value = @value)
            when NilClass
              "[nil]"
            when Symbol
              value.inspect
            when Float
              ((value * 100000).to_i / 100000.0).to_s
            when Hash
              to_s([value])
            when Array
              looks_a_relation?(value) ? 
                Text.render(value) :
                "[" + value.collect{|x| Cell.new(x).text_rendering}.join(",\n ") + "]"
            else
              value.to_s
          end
        end

      end # class Cell

      class Row
        include Utils        

        def initialize(values)
          @cells = values.collect{|v| Cell.new(v)}
        end

        def min_widths
          @cells.collect{|cell| cell.min_width}
        end

        def rendering_lines(sizes = min_widths)
          nb_lines = 0
          by_cell = @cells.zip(sizes).collect do |cell,size|
            lines = cell.rendering_lines(size)
            nb_lines = max(nb_lines, lines.size)
            lines
          end
          grid = (0...nb_lines).collect do |line_i|
            "| " + by_cell.zip(sizes).collect{|cell_lines, size|
              cell_lines[line_i] || " "*size
            }.join(" | ") + " |"
          end
          grid
        end

      end # class Row

      class Table
        include Utils

        def initialize(records, attributes)
          @header = Row.new(attributes)
          @rows = records.collect{|r| Row.new(r)}
        end

        def render(buffer = "")
          sizes = @rows.inject(@header.min_widths) do |memo,row|
            memo.zip(row.min_widths).collect{|x,y| max(x,y)}
          end
          sep = '+-' << sizes.collect{|s| '-' * s}.join('-+-') << '-+'
          buffer << sep << "\n"
          buffer << @header.rendering_lines(sizes).first << "\n"
          buffer << sep << "\n"
          @rows.each do |row|
            row.rendering_lines(sizes).each do |line|
              buffer << line << "\n"
            end
          end
          buffer << sep << "\n"
          buffer
        end

      end # class Table

      def self.render(relation, buffer = "")
        attrs = relation.first.keys
        records = relation.collect{|t|
          attrs.collect{|a| t[a]}
        }
        Table.new(records, attrs).render(buffer)
      end

    end # class Text
  end # class Formatter
end # module Bench
