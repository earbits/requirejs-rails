require 'requirejs/config/build_param_whitelist'
require 'requirejs/config/paths'

module Requirejs
  module Config
    class Build
      
      class Module < Struct.new(:name)
        def path
          name + ".js"
        end
      end
      
      def initialize(config, root_path)
        @paths = Requirejs::Config::Paths.new(root_path)
        @config = config
        @build_config ||=  { "baseUrl" =>  @paths.source.to_s, }.merge ::Requirejs::Config::BuildParamWhitelist.filter(config)
      end
      
      attr_reader :build_config, :paths
      
      def module_names
        @config["modules"].map {|mod| mod["name"]}
      end
      
      def modules
        @modules ||= @config["modules"].map { |mod| Module.new(mod["name"])}
      end
      
      def manifest_path
        @config["manifest_path"]
      end
      
      def follow_dependencies?
        !!@config["follow_dependencies"]
      end
      def logical_asset_filter
        @config["logical_asset_filter"]
      end
      
      def get_binding
        return binding()
      end
      

      
      def asset_allowed?(asset)
        self.logical_asset_filter.reduce(false) do |accum, matcher|
          accum || (matcher =~ asset)
        end ? true : false
      end
      
      def config_paths
        @config["paths"] || {}
      end
      
      def map_module_name(module_name)
        config_paths[module_name] || module_name
      end
    
    end
  end   
end