require "active_support"
require "active_support/core_ext/object/to_json"

require "requirejs/config/runtime"

module Requirejs
  module Strategies
    class Requirejs
      def initialize(config, main_module, options = {}, path_block)
        @config = config
        @main_module = main_module
        @use_digest = options[:use_digest]
        @path_block = path_block
      end

      
      def to_html
          html = ""
          
          if runtime_config_needed?
            html.concat "<script>var require = #{runtime_config.to_json};</script>\n"
          end
          
          # add require.js script call
          html.concat "<script data-main='#{data_main}' src='#{asset_path("require")}'></script>"
      end
      
      
      
      
      protected
      
      def data_main
        return @main_module if use_digest?
          asset_path(@main_module)
      end

      
      def use_digest?; @use_digest; end
      def include_paths?; @config.include_paths?; end
      
      def runtime_config_needed?
        @config.has_runtime_config? || use_digest?
      end
      
      def runtime_config
        
        config = (@config.runtime_config || {}).dup
        
        
        unless include_paths?
           config["paths"] ||= {}
           
           modules = @config.module_names
           required_paths = @config.required_paths
           
           # filter out paths
           config["paths"].select! {|mod,path| modules.include?(mod) || required_paths.include?(mod) || is_url?(path)}
        end
            
        if use_digest? 
          config["paths"] ||= {}

          #map paths
          config["paths"].each {|mod,path| config["paths"][mod] = path_digest(path) }
          config["paths"][@main_module] = path_digest(@main_module)
        end
        
        config
      end
  
      def asset_path(path)
        @path_block.call(path)
      end
      
      def is_url?(path)
        path =~ /^https?:/
      end
      
      def path_digest(path)
        # do not translate remote urls
        return path if is_url?(path)
        
        asset_path(path).sub(/\.js$/,'')
      end
      
      
    end
  end
end