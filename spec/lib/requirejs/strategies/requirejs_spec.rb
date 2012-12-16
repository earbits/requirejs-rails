require "requirejs/strategies/requirejs"
describe Requirejs::Strategies::Requirejs do
  
  let(:asset_proc) { lambda {|path| "/assets/#{path}" + (path =~ /\.js$/ ? "" : ".js")} }
  it "should render a basic script tag" do
    Requirejs::Strategies::Requirejs.new(
        stub("has_runtime_config?" => false, "include_paths?" => true), "my_module",asset_proc
      ).to_html.should eql(
        "<script data-main='/assets/my_module.js' src='/assets/require.js'></script>"
      )
  end
  
  it "should render a 'var require' script if needed" do
      
      html = Requirejs::Strategies::Requirejs.new(
          stub("has_runtime_config?" => true, "include_paths?" => true, "runtime_config" => {key: "value"}),"my_module", asset_proc
        ).to_html 
      html.should include(
          "<script>var require = {\"key\":\"value\"};</script>"
        )
      
      html.should include(
          "<script data-main='/assets/my_module.js' src='/assets/require.js'></script>"
        )
    
  end
  
  it "should use module name if use_digest sepecfied" do
    Requirejs::Strategies::Requirejs.new(
        stub("has_runtime_config?" => false, "include_paths?" => true,runtime_config: nil),
          "my_module",{use_digest: true}, asset_proc
          
      ).to_html.should include(
        "<script data-main='my_module' src='/assets/require.js'></script>"
      )
  end 
  it "should add module path to paths if use_digest sepecfied" do
    Requirejs::Strategies::Requirejs.new(
        stub("has_runtime_config?" => false, "include_paths?" => true, runtime_config: nil), 
          "my_module",{use_digest: true}, asset_proc
          
      ).to_html.should include(
       "<script>var require = {" +
         "\"paths\":{\"my_module\":\"/assets/my_module\"}};</script>"
      )
  end
  
  it "should preserver existing paths when use_digest requested" do
    Requirejs::Strategies::Requirejs.new(
        stub("has_runtime_config?" => false, "include_paths?" => true, runtime_config: {"paths" => {"sub_module" => "sub/module"}}), 
          "my_module",{use_digest: true}, asset_proc
          
      ).to_html.should include(
       "<script>var require = {" +
         "\"paths\":{\"sub_module\":\"/assets/sub/module\",\"my_module\":\"/assets/my_module\"}};</script>"
      )
  end
  
  it "should filter paths when include_paths? set to false" do
    Requirejs::Strategies::Requirejs.new(
        stub("has_runtime_config?" => false, "include_paths?" => false, "require_paths" => [], runtime_config: {"paths" => {"sub_module" => "sub/module"}}, module_names: ["my_module"]), 
          "my_module",{use_digest: true, compile: true}, asset_proc
          
      ).to_html.should include(
       "<script>var require = {" +
         "\"paths\":{\"my_module\":\"/assets/my_module\"}};</script>"
      )
  end
  
  it "should not filter paths when include_paths? set to false if path is url" do
    Requirejs::Strategies::Requirejs.new(
        stub("has_runtime_config?" => false, "include_paths?" => false, "require_paths" => [], runtime_config: {"paths" => {"sub_module" => "http://my.com/modules"}}, module_names: ["my_module"]), 
          "my_module",{use_digest: true, compile: true}, asset_proc
          
      ).to_html.should include(
       "<script>var require = {" +
         "\"paths\":{\"sub_module\":\"http://my.com/modules\"," + 
         "\"my_module\":\"/assets/my_module\"}};</script>"
      )
  end
  
  it "should not filter paths when include_paths? set to false if path is a required path" do
    Requirejs::Strategies::Requirejs.new(
        stub("has_runtime_config?" => false, "include_paths?" => false, "require_paths" => ["sub_module"], runtime_config: {"paths" => {"sub_module" => "sub/module"}}, module_names: ["my_module"]), 
          "my_module",{use_digest: true, compile: true}, asset_proc
          
      ).to_html.should include(
       "<script>var require = {" +
         "\"paths\":{\"sub_module\":\"/assets/sub/module\"," + 
         "\"my_module\":\"/assets/my_module\"}};</script>"
      )
  end
  

end