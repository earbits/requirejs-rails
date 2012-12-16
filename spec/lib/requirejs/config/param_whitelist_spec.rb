require "requirejs/config/param_whitelist"
describe Requirejs::Config::ParamWhitelist do
  
  it "should take a list of params" do
    Requirejs::Config::ParamWhitelist.new %w{ param1 param2 param 3}
  end
    
end