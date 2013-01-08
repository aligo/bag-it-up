module BagItUp
  class Assets < Sprockets::Environment

    class << self
      def instance(root)
        @instance ||= new(root)
      end
    end

    def initialize(root)
      super

      %w[app lib vendor].each do |dir|
        %w[images javascripts stylesheets].each do |type|
          path = File.join(root, dir, 'assets', type)
          self.append_path(path) if File.exist?(path)
        end
      end

      @assets_public_dir = root + '/public/assets'

      context_class.instance_eval do
        include Helpers
      end
    end

    def clean
      FileUtils.rm_rf(@assets_public_dir, secure: true)
    end

    def precompile
      clean

      self.css_compressor = YUI::CssCompressor.new
      self.js_compressor = Uglifier.new

      StaticCompiler.new(self, @assets_public_dir, ['bag.js', 'bag.css']).compile
    end

    module Helpers
      def asset_path(source)
        if settings.development
          "/assets/#{source}"
        else
          "/assets/#{Assets.instance(File.dirname(settings.root))[source].digest_path}"
        end
      end
    end

    class StaticCompiler
      attr_accessor :env, :target, :paths

      def initialize(env, target, paths, options = {})
        @env = env
        @target = target
        @paths = paths
        @digest = options.fetch(:digest, true)
        @manifest = options.fetch(:manifest, true)
        @zip_files = options.delete(:zip_files) || /\.(?:css|html|js|svg|txt|xml)$/
      end

      def compile
        manifest = {}
        env.each_logical_path(paths) do |logical_path|
          if asset = env.find_asset(logical_path)
            manifest[logical_path] = write_asset(asset)
          end
        end
        write_manifest(manifest) if @manifest
      end

      def write_manifest(manifest)
        FileUtils.mkdir_p(@target)
        File.open("#{@target}/manifest.yml", 'wb') do |f|
          YAML.dump(manifest, f)
        end
      end

      def write_asset(asset)
        path_for(asset).tap do |path|
          filename = File.join(target, path)
          FileUtils.mkdir_p File.dirname(filename)
          asset.write_to(filename)
          asset.write_to("#{filename}.gz") if filename.to_s =~ @zip_files
        end
      end

      def path_for(asset)
        @digest ? asset.digest_path : asset.logical_path
      end
    end

  end
end