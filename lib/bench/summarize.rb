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
        ByNode.new(self, index+1, key)
      else
        LeafNode.new(self, index + 1, @aggregators)
      end
    end
    
    def by(*names)
      @by += names
    end
    
    def add_aggregation(key, init_value, collector, finalizer = nil)
      @aggregators[key] = Aggregator.new(init_value, collector, finalizer)
    end
    
    def count(arg)
      case arg
      when Hash
        arg.each_pair{|k,v| count(v)}
      when Symbol, String
        add_aggregation(arg, 0, lambda{|memo, tuple| memo + 1})
      end
    end
    
    def sum(arg)
      case arg
      when Hash
        arg.each_pair{|k,v|
          add_aggregation(v, 0, lambda{|memo, tuple| memo + tuple[k]})
        }
      when Array
        sum(Hash[arg.collect{|a| [a, a]}])
      when Symbol, String
        sum(arg => arg)
      end
    end
    
    def avg(arg)
      case arg
      when Hash
        arg.each_pair{|k,v|
          add_aggregation(v, 
            [ 0, 0 ], 
            lambda{|memo, tuple| [ memo[0] + 1, memo[1] + tuple[k] ]},
            lambda{|memo| (memo[0] == 0 ? 0 : memo[1] / memo[0]) }
          )
        }
      when Array
        avg(Hash[arg.collect{|a| [a, a]}])
      when Symbol, String
        avg(arg => arg)
      end
    end
    
    def <<(tuples)
      @root = build_sub_node(-1)
      tuples.each{|t| @root << t}
      a = []
      @root.to_a(a, {})
      a
    end
    
  end # class Summarize
end # module Bench
