require "requirejs/config/build"

describe Requirejs::Config::Build do
  
  subject(:config) do 
    Requirejs::Config::Build.new( { 
        "modules" => [{"name" => "mod1"}, {"name" => "mod2"}],
        "shim" =>  "my shim"
      },
      Pathname.new("/root")
    ) 
  end

  its(:build_config) { should include("shim") }

  its(:module_names) { should eql %w{ mod1 mod2}}  
  

  
  it "should return binding" do
    config.get_binding.should_not be_nil
  end
end