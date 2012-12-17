require "set"

module Requirejs
class DependencyBuilder


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
      dependent_paths = env.direct_dependencies_for(logical_path)
      #cached_paths.merge(dependant_paths)
  
      # merge recursively, ensuring no duplication
      while !dependent_paths.empty?
        dependent_path = dependent_paths.pop
    
        unless cached_paths.include?(dependent_path)
          cached_paths << dependent_path
          dependent_paths.push(* env.direct_dependencies_for(dependent_path))
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
