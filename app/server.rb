require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/reloader'

require 'sprockets'
require 'slim'
require 'less'
require 'coffee-script'

require_relative 'extends/srcver'

class BagItUpApp < Sinatra::Base
  include Sinatra::Srcver

  set :codename, 'Bag-It-Up'
  set :sitename, 'Bag It Up'

  configure :development do
    register Sinatra::Reloader
  end

  sprockets = Sprockets::Environment.new
  sprockets.append_path root + '/assets/javascripts'
  sprockets.append_path root + '/assets/stylesheets'

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