module Viiite
  class Command
    #
    # Compare benchmarking results easily
    #
    # SYNOPSIS
    #   viiite #{command_name} [BENCHFILE]
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Compare < Quickl::Command(__FILE__, __LINE__)
      include Commons

      options do |opt|
        @by = [:bench]
        opt.on("--by=x,y,z", Array,
               "Regroup by x, then y, then z, ...") do |by|
          @by = by
        end
        @order = Alf::Types::Ordering.coerce([[:total, :asc]])
        opt.on("--order=ORDERING", 
               "Use a specific order relation", Array) do |order|
          @order = Alf::Types::Ordering.from_argv(order)
        end
        @ff = "%.6f"
        opt.on("--ff=FORMAT",
               "Specify the floating point format") do |val|
          @ff = val
        end
      end

      def query(op)
        lispy = Alf.lispy

        # 1) make summarization
        attrs = @order.to_attr_list.to_a
        first = attrs.first
        aggs  = Hash[attrs.map{|a|
          [a, "avg{ tms.#{a} }"]
        }].merge("stddev_#{first}".to_sym => "stddev{ tms.#{first} }")
        op = lispy.summarize(op, @by, aggs)

        # 2) make the sorting
        op = lispy.sort(op, @order)

        # 3) make regrouping if required
        if @by and @by.size > 1
          depend = attrs.dup + ["stddev_#{first}".to_sym]
          @by[1..-1].reverse.each do |grouping|
            op = lispy.group(op, [grouping] + depend, :measure)
            depend = [:measure]
          end
        end

        op
      end

      def execute(argv)
        op = single_source(argv) do |bdb, arg|
          bdb.dataset(arg)
        end
        op = query(op)
        Alf::Renderer.text(op, {:float_format => @ff}).execute($stdout)
      end

    end # class Report
  end # class Command
end # module Viiite
