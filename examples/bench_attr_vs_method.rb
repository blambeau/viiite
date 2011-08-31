class Foo
  attr_reader :bench_reader
  def initialize
    @bench_reader = @bench_method = 10
  end
  def bench_method
    @bench_method
  end
end

Viiite.bench do |b|
  foo = Foo.new
  b.variation_point :ruby, Viiite.which_ruby
  b.range_over([1, 100_000, 1_000_000], :runs) do |runs|
    b.report(:bench_reader){ runs.times{ foo.bench_reader } }
    b.report(:bench_method){ runs.times{ foo.bench_method } }
  end
end
