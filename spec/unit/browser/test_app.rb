require 'spec_helper'
require 'viiite/browser'
require 'rack/test'
module Viiite
  module Browser
    describe App do
      include Rack::Test::Methods

      def app
        App.new
      end

      specify "the / " do
        get '/'
        last_response.should be_ok
      end

    end
  end
end
