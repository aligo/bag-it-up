require 'rubygems'
require 'bundler'

Bundler.require

require_relative 'app/extends/assets'

namespace :assets do

  desc "Compile all the assets named in config.assets.precompile"
  task :precompile do
    BagItUp::Assets.instance(File.dirname(__FILE__)).precompile
  end

  desc "Remove compiled assets"
  task :clean do
    BagItUp::Assets.instance(File.dirname(__FILE__)).clean
  end
  
end