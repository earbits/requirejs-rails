
require 'requirejs/rails/config'
require 'requirejs/dependency_builder'

require 'requirejs/rails/helper'

require 'pathname'

module Requirejs
  class Engine < ::Rails::Engine


      ### Configuration setup
      config.before_configuration do |app|
        config.requirejs = Requirejs::Rails::Config.new #::Rails.root
        config.requirejs.precompile = [/require\.js$/]
 
      
      end
      
      

      config.before_initialize do |app|
        config = app.config
        
        # add require js files to the pre-compile...
        # is this the source of the double compile error? 
        config.assets.precompile += config.requirejs.precompile

        manifest_path = File.join(app.root, 'public', config.assets.prefix, "rjs_manifest.yml")
        config.requirejs.manifest_path = Pathname.new(manifest_path)
      end


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

      ### Initializers


      initializer "requirejs.manifest", :after => "sprockets.environment" do |app|
        config = app.config
        
        if config.requirejs.manifest_path.exist? && config.assets.digests
          rjs_digests = YAML.load(File.new(config.requirejs.manifest_path).read)
          config.assets.digests.merge!(rjs_digests)
        end
      end
      
    ## 
    

    config.after_initialize do |app|
      config = app.config
      
      ActiveSupport.on_load(:action_view) do
        include Requirejs::Rails::Helper
      end
    end

  end # class Engine
end

