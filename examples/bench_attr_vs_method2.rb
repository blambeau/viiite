require 'viiite'
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
  b.report(:bench_reader){ 1_000_000.times{ foo.bench_reader } }
  b.report(:bench_method){ 1_000_000.times{ foo.bench_method } }
end

