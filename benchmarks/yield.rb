class Foo
  def explicit &block
    yield
  end

  def implicit
    yield
  end
end

Viiite.bench do |r|
  foo = Foo.new
  r.variation_point :ruby, Viiite.which_ruby
  r.range_over([100, 100_000, 1_000_000], :size) do |n|
    r.report(:yield_implicit){ n.times{ foo.implicit{} } }
    r.report(:yield_explicit){ n.times{ foo.explicit{} } }
  end
end
