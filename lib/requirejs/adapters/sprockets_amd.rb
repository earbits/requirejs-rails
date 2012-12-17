require "requirejs/amd_path_extractor"
module Requirejs
  module Adapters
    class SprocketsAmd
    

      attr_reader :sprockets, :config
      def initialize(sprockets_env, config)
        @sprockets = sprockets_env
        @config = config
      end

      def find_asset(path)
        sprockets.find_asset(path)
      end
    
      def direct_dependencies_for(path)
    
        asset = sprockets.find_asset(path) # parse compiled file
        raise "asset not found : #{path}" if asset.nil?
      

        
        #extract module names from body
        Requirejs::AmdPathExtractor.parse(asset.body).map do |module_name|
          # check for path in config and add js to path
          config.map_module_name(module_name) + ".js"
        end.compact

      end

    end
  end

end