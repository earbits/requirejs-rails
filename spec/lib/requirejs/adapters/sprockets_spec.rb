require "requirejs/adapters/sprockets"
describe Requirejs::Adapters::Sprockets do
  
  

    let(:asset) { stub }
    it "should find an asset path" do
      adapter = Requirejs::Adapters::Sprockets.new(stub(find_asset: asset))
      adapter.find_asset("my_path").should eql(asset)
    end
    
    it "should raise error if no dependency found" do
      sprockets = stub()
      adapter = Requirejs::Adapters::Sprockets.new(sprockets)
      sprockets.stub(:find_asset).with("my_path", bundle: false).and_return(nil)
      expect { adapter.direct_dependencies_for("my_path") }.to raise_error
    end
    

    it "should return dependncies" do
     
      asset = stub(:dependency_paths => [ stub(pathname: "dep_a"), stub(pathname:"dep_b")])
      sprockets = stub
      
      sprockets.stub(:find_asset).with("my_path", bundle: false).and_return(asset)
      sprockets.stub(:find_asset).with("dep_a", bundle: false).and_return(stub(logical_path: "path_a"))
      sprockets.stub(:find_asset).with("dep_b", bundle: false).and_return(stub(logical_path: "path_b"))
      
      
      
      adapter = Requirejs::Adapters::Sprockets.new(sprockets)
      adapter.direct_dependencies_for("my_path").should eql(["path_a","path_b"])
    end
    
    
    it  "should skip directories" do
      dir = stub(pathname: "dep_dir")
      file = stub(pathname: "dep_file")
      asset = stub(:dependency_paths => [  file, dir])
      File.stub(:directory?).with("dep_dir").and_return(true)
      File.stub(:directory?).with("dep_file").and_return(false)
      sprockets = stub
      
      sprockets.stub(:find_asset).with("my_path", bundle: false).and_return(asset)
      sprockets.stub(:find_asset).with("dep_file", bundle: false).and_return(stub(logical_path: "path_a"))
      #sprockets.stub(:find_asset).with("dep_b", bundle: false).and_return(stub(logical_path: "path_b"))
      
      
       adapter = Requirejs::Adapters::Sprockets.new(sprockets)
       adapter.direct_dependencies_for("my_path").should eql(["path_a"])
    end

 
end