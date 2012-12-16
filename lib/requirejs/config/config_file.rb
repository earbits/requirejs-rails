require 'requirejs/config/build_param_whitelist'
module Requirejs
  module Config
    class ConfigFile
      def initialize(config_path)
        @config = {}
        if config_path.exist?
          @config = YAML::load(config_path.read)
        end
      end
      
      attr_reader :config
      
    end
  end
end