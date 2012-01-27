module Viiite
  class Command
    module Commons

      def database
        Database.new requester.config
      end

    end # module Commons
  end # class Command
end # module Viiite
