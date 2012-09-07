module Sinatra
  module Srcver

    module ClassMethods
      def srcver
        unless @srcver && !development?
          @srcver = {}
          if File.exist?('VERSION')
            @srcver[:ver] = File.open('REVISION', 'r').read.to_s
            @srcver[:run] = File.open('VERSION', 'r').read.to_s
          else
            @srcver[:run] = File.open('.git/HEAD', 'r') do |file|
              file.read.gsub!("ref: refs/heads/", "").strip
            end
            @srcver[:ver] = File.open(".git/refs/heads/#{@srcver[:run]}", 'r') do |file|
              file.read.gsub!("\n", "")
            end
          end
          @srcver[:log] = '=> Project ' + codename + ' srcversion.' + @srcver[:ver][0,7] + '$' + @srcver[:run] + ' on ' + environment.to_s
          @srcver[:html] = '<p>Project ' + codename + ' | srcversion.' + @srcver[:ver][0,7] + '$' + @srcver[:run] + '</p>'
        end
        @srcver
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end

  end
end