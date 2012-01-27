module Viiite
  module Unit
    
    attr_reader :path
    
    def run(reporter = nil, &block)
      reporter ||= block
      if reporter and reporter.respond_to?(:report)
        reporter.report(self)
      elsif reporter
        runner.each(&reporter)
      else
        runner
      end
    end

  end # module Unit
end # module Viiite