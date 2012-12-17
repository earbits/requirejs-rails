require "requirejs/config/build"

describe Requirejs::Config::Build do
  
  let(:config) do 
    Requirejs::Config::Build.new( { 
        "modules" => [{"name" => "mod1"}, {"name" => "mod2"}],
        "shim" =>  "my shim",
        "paths" => {"mapped_module" => "true_path"},
        "follow_dependencies" => true,
        "logical_asset_filter" =>  [/\.js$/,/\.html$/,/\.txt$/]
      },
      Pathname.new("/root")
    ) 
  end

  specify { config.build_config.should include("shim") }


  specify { config.module_names.should eql %w{ mod1 mod2}}  
  specify { config.follow_dependencies?.should be_true}
  
  specify { config.get_binding.should_not be_nil }
  
  specify { config.paths.should_not be_nil}
  specify { config.asset_allowed?("test.js").should be_true}
  specify { config.asset_allowed?("test.doc").should be_false}
  
  specify { config.modules.should include(Requirejs::Config::Build::Module.new("mod1"))}
  specify { config.modules.should include(Requirejs::Config::Build::Module.new("mod2"))}
  
  specify { config.map_module_name("mapped_module").should eql("true_path") }
  specify { config.map_module_name("unmapped_module").should eql("unmapped_module") }
end