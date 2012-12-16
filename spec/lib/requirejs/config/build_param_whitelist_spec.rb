require "requirejs/config/build_param_whitelist"
describe Requirejs::Config::BuildParamWhitelist do
  
  it "should filter params" do
    Requirejs::Config::BuildParamWhitelist.filter({"bad" =>  "param", "shim" => "my shim"}).should eql({"shim" => "my shim"})
  end
  whitelisted_params = %w{
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
  
  whitelisted_params.each do |param|
    it "should allow #{param}" do
      Requirejs::Config::BuildParamWhitelist.filter({"bad" =>  "param", param => "my param"}).should eql({param => "my param"})
    end
  end

    
end