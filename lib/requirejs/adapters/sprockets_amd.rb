require "requirejs/amd_path_extractor"
module Requirejs
  module Adapters
    class SprocketsAmd
    

      attr_reader :sprockets
      def initialize(sprockets_env, config)
        @sprockets = sprockets_env
        @config = config
      end

      def find_asset(path)
        sprockets.find_asset(path)
      end
    
      def direct_dependencies_for(path)
    
        asset = sprockets.find_asset(path, :bundle => false)
    
        raise "asset not found : #{path}" if asset.nil?
      

        
        #extract module names from body
        Requirejs::AmdPathExtractor.parse(asset.body).map do |module_name|
          # check for path in config and add js to path
          dependency_file = @config.map_module_name(module_name) + ".js"
          
          logical_path_for(dependency_file) 
        end.compact
        

      end
    
      private
      def logical_path_for(dependency_file)
         return nil if  File.directory?(dependency_file.pathname)
         sprockets.find_asset(dependency_file.pathname, :bundle => false).logical_path
       end
    end
  end

end