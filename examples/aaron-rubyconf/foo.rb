class Foo
  
  attr_reader :via_reader
  
  def initialize
    @via_reader = @via_method = 10
  end
  
  def via_method
    @via_method
  end
  
end
