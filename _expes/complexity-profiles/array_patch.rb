# array_patch.rb
class Array
  
  def bubblesort
    sarray = self.clone
    for i in 0..(sarray.length - 1)
      for j in 0..(sarray.length - i - 2)
        if ( sarray[j + 1] <=> sarray[j] ) == -1
          sarray[j], sarray[j + 1] = sarray[j + 1], sarray[j]
        end
      end
    end
    sarray
  end
  
  def self.random(size) 
    Array.new(size){ Kernel.rand }
  end
  
end
