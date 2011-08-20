module Bench
  class Command
    #
    # Run a benchmark and summarize results
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [BENCHFILE]
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
        case args
        when Array
          raise Quickl::InvalidArgument if args.size > 1
          execute Alf::Reader.reader(args.first || $stdin)
        when Alf::Iterator
          Alf::Renderer.text(query(args)).execute($stdout)
        else 
          raise ArgumentError, "Unable to report from #{args.inspec}"
        end
      end

    end # class Report
  end # class Command
end # module Bench

