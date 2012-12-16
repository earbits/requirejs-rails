module Requirejs
  module Config
    class ParamWhitelist
      def initialize(params)
        @params = Set.new(params)
      end
      
      def filter(config)
        config.select {|key| @params.include?(key) }
      end
      
      def self.filter(config)
        self.new.filter(config)
      end
    end
  end
end