require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/reloader'

require 'sprockets'
require 'slim'
require 'less'
require 'coffee-script'


require_relative 'extends/assets'
require_relative 'extends/srcver'

module BagItUp

  class WebServer < Sinatra::Base
    include BagItUp::Srcver
    helpers BagItUp::Assets::Helpers

    set :root, File.dirname(__FILE__)
    set :environment, ENV['ENV'] || 'development'
    set :development, environment == 'development' ? true : false

    set :codename, 'Bag-It-Up'
    set :sitename, 'Bag It Up'

    configure :development do
      register Sinatra::Reloader
    end

    $stderr.puts self.srcver[:log]

    get '/' do
      slim :index
    end

    if development
      get '/assets/:file' do
        asset = BagItUp::Assets.instance(File.dirname(settings.root))["#{params[:file]}"]
        content_type asset.content_type
        asset
      end
    end

  end

end

if __FILE__ == $0
  BagItUp::WebServer.run! :port => 3000
end