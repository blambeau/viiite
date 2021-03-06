class Array

  def quicksort(list = self)
     return list if list.nil? or list.size <= 1
     less, more = list[1..-1].partition { |i| i < list[0] }
     quicksort(less) + [list[0]] + quicksort(more)
  end

  def bubblesort(list = self)
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

end

Viiite.bench do |b|
  b.variation_point :ruby, Viiite.which_ruby
  b.range_over([100, 200, 300, 400, 500], :size) do |size|
    b.range_over(1..5, :i) do
      bench_case = Array.new(size) { rand }
      b.report(:quicksort) { bench_case.quicksort }
      b.report(:bubblesort){ bench_case.bubblesort }
    end
  end
end
