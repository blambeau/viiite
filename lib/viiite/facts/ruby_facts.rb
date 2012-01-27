module Viiite
  module RubyFacts

    def which
      if Object.const_defined?(:RUBY_DESCRIPTION)
        short_ruby_description(RUBY_DESCRIPTION)
      else
        "ruby #{RUBY_VERSION}"
      end
    end

    private

    def short_ruby_description(description)
      case description
      when /Ruby Enterprise Edition (\d{4}\.\d{2})/
        "ree #{$1}"
      when /^(\w+ \d\.\d\.\d) .+ patchlevel (\d+)/
        "#{$1}p#{$2}"
      when /^\w+ \S+/
        $&
      else
        raise "Unknown ruby interpreter: #{description}"
      end
    end

    extend(RubyFacts)
  end # module RubyFacts
end # module Viiite