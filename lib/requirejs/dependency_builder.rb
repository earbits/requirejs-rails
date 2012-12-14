require "set"
module Requirejs
  class DependencyBuilder
  
    class SprocketsAdapter
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
  
  
    attr_reader :env
    attr_reader :cached_paths
  
    def initialize(dependancy_adapter)
      @env = dependancy_adapter
      @cached_paths = Set.new
    end
  
    def include(logical_path)
      cached_paths << logical_path
    
      # build sub dependencies
      dependant_paths = env.direct_dependencies_for(logical_path)
      #cached_paths.merge(dependant_paths)
    
      # merge recursively, ensuring no duplication
      while !dependant_paths.empty?
        dependant_path = dependant_paths.pop
      
        unless cached_paths.include?(dependant_path)
          cached_paths << dependant_path
          dependant_paths.push(* env.direct_dependencies_for(dependant_path))
        end
      end
    end
  
    def dependency_paths
      cached_paths.to_a
    end
    
    def each(&block)
      cached_paths.each(&block)
    end
    
  end
end