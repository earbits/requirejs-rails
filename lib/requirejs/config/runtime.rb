require 'requirejs/config/runtime_param_whitelist'
module Requirejs
  module Config
    class Runtime
      def initialize(config)
        @config = config
        @runtime_config ||=  { "baseUrl" => "/assets" }.merge ::Requirejs::Config::RuntimeParamWhitelist.filter(config)
      end
      
      attr_reader :runtime_config
      
      
      def has_runtime_config?
        !@runtime_config.empty?
      end
      
      def include_paths?
        @config["include_paths"]
      end
      
      def module_names
        @config["modules"].map {|mod| mod["name"]}
      end
      
      def required_paths
        @config["required_paths"] || []
      end

    end
  end
end