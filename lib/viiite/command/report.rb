module Viiite
  class Command
    #
    # Report benchmarking results as a table
    #
    # SYNOPSIS
    #   viiite #{command_name} [BENCHFILE]
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Report < Quickl::Command(__FILE__, __LINE__)

      options do |opt|

        @regroup = [:bench]
        opt.on("--regroup=x,y,z", Array,
               "Regroup by x, then y, then z, ...") do |group|
          @regroup = group
        end

        @hierarchy = false
        opt.on('-h', "--hierarchy", "Make a hierarchical regrouping") do
          @hierarchy = true
        end

      end

      def query(op)
        lispy = Alf.lispy
        op = lispy.summarize(op, @regroup, :measure => lispy.avg{tms})
        @regroup[1..-1].each do |grouping|
          op = lispy.group(op, [grouping] + [:measure], :measure)
        end if @hierarchy 
        op
      end

      def execute(args)
        raise Quickl::InvalidArgument if args.size > 1
        op = query Alf::Reader.reader(args.first || $stdin)
        Alf::Renderer.text(op).execute($stdout)
      end

    end # class Report
  end # class Command
end # module Viiite

