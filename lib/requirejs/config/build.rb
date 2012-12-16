require 'requirejs/config/build_param_whitelist'
module Requirejs
  module Config
    class Build
      def initialize(config, root_path)
        @config = config
        @build_config ||=  { }.merge ::Requirejs::Config::BuildParamWhitelist.filter(config)
      end
      
      attr_reader :build_config
      
      def module_names
        @config["modules"].map {|mod| mod["name"]}
      end
      
      
      def get_binding
        return binding()
      end
    
    end
  end   
end