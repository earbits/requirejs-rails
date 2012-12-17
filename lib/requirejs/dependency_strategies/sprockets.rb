require "set"
require "requirejs/amd_path_extractor"
module Requirejs
  module DependencyStrategies
    class Sprockets
  
      class Adapter
        attr_reader :sprockets
        def initialize(sprockets_env)
          @sprockets = sprockets_env
        end
 
        def find_asset(path)
          sprockets.find_asset(path)
        end
      
        def direct_dependencies_for(path, &block)
      
          asset = sprockets.find_asset(path, :bundle => false)
      
          raise "asset not found : #{path}" if asset.nil?
        
          direct_dependencies = Set.new
          # add any for inline dependencies
          direct_dependencies.merge(
              block.call(asset.body)
            ) if block
     
          # add require block dependancies
          direct_dependencies.merge(
              asset.send(:dependency_paths).map do |dependency_file|
                logical_path_for(dependency_file) 
              end.compact
            )
          direct_dependencies.to_a
        end
      
        private
        def logical_path_for(dependency_file)
           return nil if  File.directory?(dependency_file.pathname)
           sprockets.find_asset(dependency_file.pathname, :bundle => false).logical_path
         end
      end
  
  
      attr_reader :env
      attr_reader :cached_paths
  
      def initialize(dependancy_adapter, config)
        @env = dependancy_adapter
        @config = config
        @cached_paths = Set.new
      end
  
      def include(logical_path)
        cached_paths << logical_path
    
        # build sub dependencies
        dependent_paths = extract_direct_dependents(logical_path)
        #cached_paths.merge(dependant_paths)
    
        # merge recursively, ensuring no duplication
        while !dependent_paths.empty?
          dependent_path = dependent_paths.pop
      
          unless cached_paths.include?(dependent_path)
            cached_paths << dependent_path
            dependent_paths.push(* extract_direct_dependents(dependent_path))
          end
        end
      end
    

      def dependency_paths
        cached_paths.to_a
      end
    
      def each(&block)
        cached_paths.each(&block)
      end
    
      private
    
      def extract_direct_dependents(path)
        env.direct_dependencies_for(path) do |body|
        
          #extract module names from body
          Requirejs::AmdPathExtractor.parse(body).map do |module_name|
            # check for path in config and add js to path
            @config.map_module_name(module_name) + ".js"
          end
        
        end
      end
    
    
    end
  end
end