module Requirejs
  module Adapters
    class Sprockets
    
   
      attr_reader :sprockets
      def initialize(sprockets_env)
        @sprockets = sprockets_env
      end

      def find_asset(path)
        sprockets.find_asset(path)
      end

      def direct_dependencies_for(path)

        asset = sprockets.find_asset(path, :bundle => false)

        raise "asset not found : #{path}" if asset.nil?


        asset.send(:dependency_paths).map do |dependency_file|
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