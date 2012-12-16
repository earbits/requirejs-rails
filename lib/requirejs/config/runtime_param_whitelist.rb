require "requirejs/config/param_whitelist"
module Requirejs
  module Config
    class RuntimeParamWhitelist < ParamWhitelist
      def initialize
        super  %w{
          baseUrl
          callback
          catchError
          context
          deps
          jQuery
          locale
          map
          packages
          paths
          priority
          scriptType
          shim
          urlArgs
          waitSeconds
          xhtml
        }
      end
      
      
    end
  end
end