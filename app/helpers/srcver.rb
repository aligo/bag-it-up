module BagItUp
  module Srcver

    def srcver
      unless settings.srcver && !settings.development?
        srcver = {}
        if File.exist?(settings.root + '/../VERSION')
          srcver[:ver] = File.open(settings.root + '/../REVISION', 'r').read.to_s
          srcver[:run] = File.open(settings.root + '/../VERSION', 'r').read.to_s
        else
          srcver[:run] = File.open(settings.root + '/../.git/HEAD', 'r') do |file|
            file.read.gsub!("ref: refs/heads/", "").strip
          end
          srcver[:ver] = File.open(settings.root + "/../.git/refs/heads/#{srcver[:run]}", 'r') do |file|
            file.read.gsub!("\n", "")
          end
        end
        srcver[:log] = '=> Project ' + settings.codename + ' srcversion.' + srcver[:ver][0,7] + '$' + srcver[:run] + ' on ' + settings.environment.to_s
        srcver[:html] = '<p>Project ' + settings.codename + ' | srcversion.' + srcver[:ver][0,7] + '$' + srcver[:run] + '</p>'
        
        settings.srcver = srcver
      end
      settings.srcver
    end

  end
end