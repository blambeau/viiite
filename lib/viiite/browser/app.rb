require 'sinatra/base'
module Viiite
  module Browser
    class App < Sinatra::Base

      def self._(path)
        File.expand_path(path, File.dirname(__FILE__))
      end
      def _(path); self.class._(path); end

      def bdb;   @bdb ||= BDB.new;  end
      def lispy; Alf.lispy();       end

      set :public, _('public')

      get '/' do
        send_file _("public/index.html")
      end

      get '/benchmarks.json' do
        content_type :json
        bdb.to_rel.project([:name]).to_json
      end

      get '/data/*.json' do
        bench = params[:splat].first
        content_type :json
        oldout, $stdout = $stdout, StringIO.new
        options = %w{--highcharts -x size -y tms.total --series=ruby --graph=bench}
        Command.new(bdb).run(%w{plot} + options + [bench])
        oldout, $stdout = $stdout, oldout
        oldout.string
      end

    end # class App
  end # module Browser
end # module Viiite
