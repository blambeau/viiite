# This benchmark shows how much time "n.times {}" takes for large n.
# It is relevant because we often have n.times { ... } for benchmarking fast methods without a natural "n".
# But this might be wrong if n is really large.
# So be sure your n.times { ... } is taking an insignificant amount of time in your benchmark before interpreting.
# It also shows n.times {} does not take a constant time accross implementations.

Viiite.bench do |r|
  r.variation_point :ruby, Viiite.which_ruby
  r.range_over((1..10).map { |i| i*1_000_000 }, :size) do |n|
    r.report(:times) { n.times {} }
  end
end
