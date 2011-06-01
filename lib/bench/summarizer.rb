module Bench
  class Summarizer
    
    class ByNode
      include Enumerable
      
      def initialize(key, factory)
        @key = key
        @subtree = Hash.new{|h, k| h[k] = factory.call()}
      end
      
      def <<(tuple)
        @subtree[tuple[@key]] << tuple
      end

      def each
        @subtree.each_pair do |k,v|
          v.each{|t| yield t.merge(@key => k)}
        end
      end
      
    end # class ByNode

    class PivotNode < ByNode

      def each
        tuple = {}
        @subtree.each_pair do |k,v| 
          tuple[k] = v.to_a
        end
        yield tuple
      end

    end # class PivotNode
    
    class LeafNode
      include Enumerable
      
      def initialize(aggregators)
        @aggregators = aggregators
        @aggregation = {}
        aggregators.each_pair{|key,agg|
          @aggregation[key] = agg.init_value
        }    
      end
      
      def <<(tuple)
        @aggregators.each_pair{|key, agg|
          @aggregation[key] = agg.collect(@aggregation[key], tuple)
        }
      end
      
      def finalize
        f = {}
        @aggregators.each_pair{|key,agg|
          f[key] = agg.finalize(@aggregation[key])
        }
        f
      end

      def each
        yield(finalize)
      end
      
    end # class LeafNode
    
    def initialize
      @nodes = []
      @aggregators = {}
      yield self
    end
    
    def build_sub_node(index)
      kind, key = @nodes[index + 1]
      case kind
        when :by 
          ByNode.new(key, lambda{ build_sub_node(index + 1) })
        when :pivot
          PivotNode.new(key, lambda{ build_sub_node(index + 1) })
        when NilClass
          LeafNode.new(@aggregators)
        else
          raise "Unexpected node kind #{kind}"
      end
    end

    # Factory methods (public DSL)
    
    def by(*names)
      @nodes += names.collect{|n| [:by, n]}
    end
    
    def pivot(*names)
      @nodes += names.collect{|n| [:pivot, n]}
    end
    
    def count(arg)
      aggregate(arg, :count)
    end
    
    def sum(arg)
      aggregate(arg, :sum)
    end
    
    def avg(arg)
      aggregate(arg, :avg)
    end
    
    # Running methods

    def summarize(tuples)
      root = build_sub_node(-1)
      tuples.each{|t| root << t}
      root
    end

    # Private API

    private
    
    def add_aggregation(key, aggregator)
      @aggregators[key] = aggregator
    end
    
    def aggregate(arg, function)
      case arg
      when Hash
        arg.each_pair{|k,v| add_aggregation(v, Aggregator.send(function, k))}
      when Array
        aggregate(Hash[arg.collect{|a| [a, a]}], function)
      when Symbol, String
        aggregate({arg => arg}, function)
      end
    end
    
  end # class Summarizer
end # module Bench
