require 'rubygems'
require 'bundler'

Bundler.require

require_relative 'app/extends/assets'

namespace :assets do

  task :precompile do
    BagItUp::Assets.instance(File.dirname(__FILE__)).precompile
  end

  task :clean do
    BagItUp::Assets.instance(File.dirname(__FILE__)).clean
  end
  
end