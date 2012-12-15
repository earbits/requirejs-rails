require "action_controller/railtie"

require 'requirejs/rails/config'
require 'requirejs/dependency_builder'

require 'requirejs/rails/helper'

require 'pathname'

module Requirejs
  class Railtie < ::Rails::Railtie

      ### Configuration setup
      config.before_configuration do |app|
        config.requirejs = Requirejs::Rails::Config.new
        config.requirejs.precompile = [/require\.js$/]

        # Location of the user-supplied config parameters, which will be
        # merged with the default params.  It should be a YAML file with
        # a single top-level hash, keys/values corresponding to require.js
        # config parameters.
        config.requirejs.user_config_file = Pathname.new(app.paths["config"].first)+'requirejs.yml'
        if config.requirejs.user_config_file.exist?
          config.requirejs.user_config = YAML.load(ERB.new(config.requirejs.user_config_file.read).result)
        else
          config.requirejs.user_config = {}
        end
      end

      config.before_initialize do |app|
        config = app.config
        config.assets.precompile += config.requirejs.precompile

        manifest_path = File.join(::Rails.public_path, config.assets.prefix, "rjs_manifest.yml")
        config.requirejs.manifest_path = Pathname.new(manifest_path)
      end

      ### Initializers
      initializer "requirejs.tag_included_state" do |app|
        ActiveSupport.on_load(:action_controller) do
          ::ActionController::Base.class_eval do
            attr_accessor :requirejs_included
          end
        end
      end

      initializer "requirejs.manifest", :after => "sprockets.environment" do |app|
        config = app.config
        if config.requirejs.manifest_path.exist? && config.assets.digests
          rjs_digests = YAML.load(ERB.new(File.new(config.requirejs.manifest_path).read).result)
          config.assets.digests.merge!(rjs_digests)
        end
      end
      
    ## 
    
    rake_tasks do |app|
      require 'requirejs/rails/task'

      Requirejs::Rails::Task.new 
      # do |t|
      #   t.environment = lambda { app.assets }
      #   t.output      = File.join(app.root, 'public', app.config.assets.prefix)
      #   t.assets      = app.config.assets.precompile
      #   t.cache_path  = "#{app.config.root}/tmp/cache/assets"
      # end
    end
      
    config.after_initialize do |app|
      config = app.config
      
      ActiveSupport.on_load(:action_view) do
        include Requirejs::Rails::Helper
      end
    end

  end # class Railtie
end

