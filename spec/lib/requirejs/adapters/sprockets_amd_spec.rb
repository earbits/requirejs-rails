require "requirejs/adapters/sprockets_amd"
describe Requirejs::Adapters::SprocketsAmd do
  
  let(:asset) { stub }
  let(:config) { stub }
  let(:sprockets) {stub}
  it "should find an asset path" do
    adapter = Requirejs::Adapters::SprocketsAmd.new(stub(find_asset: asset), config)
    adapter.find_asset("my_path").should eql(asset)
  end
  
  it "should raise error if no dependency found" do
    adapter = Requirejs::Adapters::SprocketsAmd.new(sprockets, config)
    sprockets.stub(:find_asset).with("my_path").and_return(nil)
    expect { adapter.direct_dependencies_for("my_path") }.to raise_error
  end
  
  
  
  it "should return dependncies" do
   
    asset.stub(body: "body")
    config.stub(:map_module_name).with("path_a").and_return("path_a")
    config.stub(:map_module_name).with("path_b").and_return("path_b")
 
    sprockets.stub(:find_asset).with("my_path").and_return(asset)
    Requirejs::AmdPathExtractor.stub(:parse).with("body").and_return(["path_a", "path_b"])
    
    adapter = Requirejs::Adapters::SprocketsAmd.new(sprockets,config)
    adapter.direct_dependencies_for("my_path").should eql(["path_a.js","path_b.js"])
  end
  
  
end