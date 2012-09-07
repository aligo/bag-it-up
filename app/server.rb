require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/reloader'

require 'sprockets'
require 'slim'
require 'less'
require 'coffee-script'

@root = File.dirname(__FILE__)

require_relative 'extends/srcver'
require_relative 'extends/sprockets'

class BagItUpApp < Sinatra::Base
  include Sinatra::Srcver

  set :root, @root
  set :environment, ENV['ENV'] || 'development'

  set :codename, 'Bag-It-Up'
  set :sitename, 'Bag It Up'

  configure :development do
    register Sinatra::Reloader
  end

  print self.srcver[:log] + "\n"

  get '/' do
    slim :index
  end

  get '/assets/:file.js' do
    content_type 'application/javascript'
    sprockets["#{params[:file]}.js"]
  end

  get '/assets/:file.css' do
    content_type 'text/css'
    sprockets["#{params[:file]}.css"]
  end

end

if __FILE__ == $0
  BagItUpApp.run! :port => 3000
end