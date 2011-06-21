class Array
  def self.random(size)
    Array.new(size){ Kernel.rand }
  end
end

def quicksort(v)
   return v if v.nil? or v.length <= 1
   less, more = v[1..-1].partition { |i| i < v[0] }
   quicksort(less) + [v[0]] + quicksort(more)
end

def bubblesort(list)
  slist = list.clone
  for i in 0..(slist.length - 1)
    for j in 0..(slist.length - i - 2)
    	if ( slist[j + 1] <=> slist[j] ) == -1
    		slist[j], slist[j + 1] = slist[j + 1], slist[j]
    	end
    end
  end
  slist
end

def rubysort(list)
  list.sort
end

def rubysort!(list)
  list.sort!
end