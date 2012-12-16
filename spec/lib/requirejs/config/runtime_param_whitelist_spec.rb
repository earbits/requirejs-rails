require "requirejs/config/runtime_param_whitelist"
describe Requirejs::Config::RuntimeParamWhitelist do
  
  it "should filter params" do
    Requirejs::Config::RuntimeParamWhitelist.filter({"bad" =>  "param", "shim" => "my shim"}).should eql({"shim" => "my shim"})
  end
  
  
  whitelisted_params =  %w{
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
  
  whitelisted_params.each do |param|
    it "should allow #{param}" do
      Requirejs::Config::RuntimeParamWhitelist.filter({"bad" =>  "param", param => "my param"}).should eql({param => "my param"})
    end
  end
  
end