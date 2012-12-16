require "requirejs/config/param_whitelist"
module Requirejs
  module Config
    class BuildParamWhitelist < ParamWhitelist
      def initialize
        super %w{
          appDir
          baseUrl
          closure
          cssImportIgnore
          cssIn
          dir
          fileExclusionRegExp
          findNestedDependencies
          has
          hasOnSave
          include
          inlineText
          locale
          mainConfigFile
          map
          modules
          name
          namespace
          onBuildRead
          onBuildWrite
          optimize
          optimizeAllPluginResources
          optimizeCss
          out
          packagePaths
          packages
          paths
          pragmas
          pragmasOnSave
          preserveLicenseComments
          shim
          skipModuleInsertion
          skipPragmas
          uglify
          useStrict
          wrap
        }
      end
      
      
    end
  end
end