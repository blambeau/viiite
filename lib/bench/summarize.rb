module Bench
  class Summarize
    
    class ByNode
      
      def initialize(summarize, index, key)
        @key = key
        @subtree = Hash.new{|h, k|
          h[k] = summarize.build_sub_node(index)
        }
      end
      
      def <<(tuple)
        @subtree[tuple[@key]] << tuple
      end
      
      def to_a(collect, parent_hash)
        @subtree.each_pair do |k,v|
          v.to_a(collect, parent_hash.merge(@key => k))
        end
      end
      
    end
    
    class LeafNode
      
      attr_reader :aggregation
      
      def initialize(summarize, index, aggregators)
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
      
      def to_a(collect, parent_hash)
        collect << parent_hash.merge(finalize)
      end
      
    end
    
    def initialize
      @by = []
      @aggregators = {}
      yield self
    end
    
    def build_sub_node(index)
      if key = @by[index + 1]
        ByNode.new(self, index + 1, key)
      else
        LeafNode.new(self, index + 1, @aggregators)
      end
    end
    
    def by(*names)
      @by += names
    end
    
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
    
    def count(arg)
      aggregate(arg, :count)
    end
    
    def sum(arg)
      aggregate(arg, :sum)
    end
    
    def avg(arg)
      aggregate(arg, :avg)
    end
    
    def collect
      @root = build_sub_node(-1)
      yield(@root)
      a = []
      @root.to_a(a, {})
      a
    end
    
    def <<(tuples)
      collect{|root| 
        tuples.each{|t| @root << t}
      }
    end
    
  end # class Summarize
end # module Bench
