require "requirejs/config/runtime"

describe Requirejs::Config::Runtime do
  
  subject(:config) do 
    Requirejs::Config::Runtime.new({ 
      "modules" => [{"name" => "mod1"}, {"name" => "mod2"}],
      "shim" =>  "my shim"
    }) 
  end
  
  its(:runtime_config) { should include("baseUrl") }
  its(:runtime_config) { should include("shim") }

  its(:module_names) { should eql %w{ mod1 mod2}}  
end