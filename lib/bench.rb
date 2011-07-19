require "bench/version"
require "bench/loader"
require "benchmark"

#
# Benchmarking and complexity analyzer utility
#
module Bench

  class Runner
    include Alf::Iterator

    def initialize(defn)
      @defn = defn
    end

    ### DSL
    
    def with(hash)
      if block_given?
        @stack << @stack.last.merge(hash)
        res = yield
        @stack.pop
        res
      else
        @stack.last.merge!(hash)
      end  
    end

    def range_over(range, name, &block)
      range.each do |value|
        with(name => value){ block.call(value) }
      end
    end
  
    def variation_point(name, value, &proc)
      h = {name => value}
      with(h, &proc)
    end
    
    def report(hash = {}, &block)
      with(hash) {
        measure = Benchmark.measure{ block.call }
        with :stime => measure.stime,
             :utime => measure.utime,
             :cstime => measure.cstime,
             :cutime => measure.cutime,
             :total => measure.total,
             :real  => measure.real do
          output
        end
      }
    end

    ### Alf contract
    
    def each(&reporter)
      self.dup._each(&reporter)
    end
    
    protected    

    def _each(&reporter)
      @stack, @reporter = [ {} ], reporter
      self.instance_eval &@defn
      @stack, @reporter = nil, nil
    end
    
    def output
      @reporter.call @stack.last.dup
    end

  end # class Runner

  # Formatter
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

  # .bench file 
  class BenchFile < Alf::Reader

    # (see Alf::Reader#each)
    def each
      op = if input.is_a?(String)
        Kernel.instance_eval(input_text, input)
      else
        Kernel.instance_eval(input_text)
      end
      op.each(&Proc.new)
    end
    
    Alf::Reader.register(:bench, [".bench"], self)
  end # class BenchFile
  
  # Builds a runner instance via the DSL definition given by the block.
  #
  # Example
  #
  #  Bench.runner do |b|
  #    b.variation_point :ruby_version, Bench.which_ruby
  #    b.range_over([100, 1000, 10000, 100000], :runs) do |runs|
  #      b.variation_point :test, :via_reader do
  #        b.report{ runs.times{ foo.via_reader } }
  #      end
  #      b.variation_point :test, :via_method do
  #        b.report{ runs.times{ foo.via_method } }
  #      end
  #    end
  #  end
  # 
  def self.runner(&block)
    Runner.new(block)
  end

  #
  # Returns a short string with a ruby interpreter description
  # 
  def self.which_ruby
    if Object.const_defined?(:RUBY_DESCRIPTION)
      RUBY_DESCRIPTION =~ /^([^\s]+\s*[^\s]+)/
      $1
    else
      "ruby #{RUBY_VERSION} (#{RUBY_PLATFORM})"
    end
  end

  #
  # bench - Benchmark ruby scripts the easy way
  #
  # SYNOPSIS
  #   #{program_name} [--version] [--help] COMMAND [cmd opts] ARGS...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # COMMANDS
  # #{summarized_subcommands}
  #
  # DESCRIPTION
  #   This command helps you benchmarking ruby applications and manipulating
  #   benchmark results very simply.
  #
  # See '#{program_name} help COMMAND' for more information on a specific command.
  #
  class Command < Quickl::Delegator(__FILE__, __LINE__)
  
    # 
    # Show help about a specific command
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} COMMAND
    #
    class Help < Quickl::Command(__FILE__, __LINE__)
      
      # Let NoSuchCommandError be passed to higher stage
      no_react_to Quickl::NoSuchCommand
      
      # Command execution
      def execute(args)
        if args.size != 1
          puts super_command.help
        else
          cmd = has_command!(args.first, super_command)
          puts cmd.help
        end
      end
      
    end # class Help

    # 
    # Run a benchmark 
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} BENCHFILE
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Run < Quickl::Command(__FILE__, __LINE__)
      
      def execute(args)
        raise Quickl::InvalidArgument if args.size > 1
        BenchFile.new(args.first || $stdin).each do |tuple|
          puts tuple.inspect
        end
      end

    end # class Run

    # 
    # Generates a plot
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [BENCHFILE]
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Plot < Quickl::Command(__FILE__, __LINE__)
      include Alf::Lispy
    
      # Install options
      options do |opt|
        @render = :text
        opt.on('--text', "Render output as a text table") do
          @render = :text
        end

        opt.on("--gnuplot=[TERM]", 
               "Render output as a gnuplot text (and terminal)") do |value|
          @render = :gnuplot
          @term = (value || "dumb").to_sym
        end
        
        opt.on('--style=FILE', "Joins a graph style file") do |value|
          @style = value
        end
        
        @graph = nil
        opt.on('-g graph', "Specify multi-graph attribute") do |value|
          @graph = value.to_sym
        end
        
        @abscissa = :x
        opt.on('-x abscissa', "Specify abscissa attribute") do |value|
          @abscissa = value.to_sym
        end
        
        @ordinate = :y
        opt.on('-y ordinate', "Specify ordinate attribute") do |value|
          @ordinate = value.to_sym
        end
        
        @series = :series
        opt.on('-s series', "Specify series attribute") do |value|
          @series = value.to_sym
        end
      end
    
      def query(op)
        op = (project op, [@graph, @abscissa, @ordinate, @series])
        op = (join op, Alf::Reader.reader(@style)) if @style
        op = (rename op, @graph => :graph, 
                         @abscissa => :x, 
                         @ordinate => :y, 
                         @series => :serie)
         op = (summarize op, [:y], {:y => Agg::avg(:y)}, true)
         op = (group op, [:x, :y], :data)
         op = (group (rename op, :serie => :title), [:graph], :series, true)
         op = (rename op, :graph => :title)
      end
      
      def execute(args)
        raise Quickl::InvalidArgument if args.size > 1
        op = query Alf::Reader.reader(args.first || $stdin)
        case @render
        when :text
          Alf::Renderer.text(op).execute($stdout)
        when :gnuplot
          $stdout << "set terminal #{@term}\n"
          Bench::Formatter::Plot::to_plots(op.to_a, $stdout)
        end
      end
    
    end # class Plot

    # Install options
    options do |opt|
      opt.on_tail("--help", "Show help") do
        raise Quickl::Help
      end
      opt.on_tail("--version", "Show version") do
        raise Quickl::Exit, "#{program_name} #{Bench::VERSION} (c) 2011, Bernard Lambeau"
      end
    end
  
  end # class Command

end # module Bench