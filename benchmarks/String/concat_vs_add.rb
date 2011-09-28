Viiite.bench do |b|
  str = ('a'..'j').to_a.join
  b.range_over((1..10).map { |i| i * 1_000_000 }, :size) do |i|
    s = str * i
    b.report("String#+") { s + s }
    b.report("String#<<") { s << s }
  end
end
