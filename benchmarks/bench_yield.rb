require 'viiite'
class Foo

  def explicit &block
    yield
  end
  
  def implicit
    yield
  end

end

Viiite.bm do |r|
  foo = Foo.new
  r.variation_point :ruby, Viiite.which_ruby
  r.range_over([100, 100_000, 1_000_000], :runs) do |n|
    r.range_over(1..5, :i) do 
      r.report(:yield_implicit){ n.times{ foo.implicit{} } }
      r.report(:yield_explicit){ n.times{ foo.explicit{} } }
    end
  end
end
