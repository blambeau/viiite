module Viiite
  module Reporter

    def report(bench_or_suite)
      bench_or_suite.run.each do |tuple|
        call(tuple)
      end
    end

  end # module Reporter
end # module Viiite
require 'viiite/reporter/rash'