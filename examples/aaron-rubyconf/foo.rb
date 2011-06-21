class Foo
  
  attr_reader :bench_reader
  
  def initialize
    @bench_reader = @bench_method = 10
  end
  
  def bench_method
    @bench_method
  end
  
end
