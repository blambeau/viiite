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

        @ff = "%.6f"
        opt.on("--ff=FORMAT", 
               "Specify the floating point format") do |val|
          @ff = val
        end
      end

      def query(op)
        lispy = Alf.lispy
        op = lispy.summarize(op, @regroup, :user   => lispy.avg{tms.utime},
                                           :system => lispy.avg{tms.stime},
                                           :total  => lispy.avg{tms.total},
                                           :real   => lispy.avg{tms.real})
        depend = [:user, :system, :total, :real]
        @regroup[1..-1].each do |grouping|
          op = lispy.group(op, [grouping] + depend, :measure)
          depend = [:measure]
        end if @hierarchy 
        op
      end

      def source(arg)
        if arg.is_a?(IO) || File.exists?(arg.to_s)
          Alf::Reader.reader(arg)
        elsif requester && requester.respond_to?(:bdb)
          requester.bdb.dataset(arg.to_s)
        else
          raise Quickl::InvalidArgument, "Missing benchmark #{arg}"
        end
      end

      def execute(args)
        raise Quickl::InvalidArgument if args.size > 1
        op = query(source(args.first || $stdin))
        Alf::Renderer.text(op, {:float_format => @ff}).execute($stdout)
      end

    end # class Report
  end # class Command
end # module Viiite

