require "requirejs/dependency_builder"
describe Requirejs::DependencyBuilder do

  before do
    @adapter = stub
    @adapter.stub(:direct_dependencies_for).with("my_path.js").and_return(["my_dependant_path.js"])
    @adapter.stub(:direct_dependencies_for).with("my_dependant_path.js").and_return(["my_other_dependant_path.js", "my_third_dependant_path.js"])
    @adapter.stub(:direct_dependencies_for).with("my_other_dependant_path.js").and_return([])
      @adapter.stub(:direct_dependencies_for).with("my_third_dependant_path.js").and_return([])
  end
  it "should include a give path as a dependency" do
    builder = Requirejs::DependencyBuilder.new(@adapter)
    builder.include("my_path.js")
    builder.dependency_paths.should include("my_path.js")
  end
  
  it "should include direct dependant paths" do
    builder = Requirejs::DependencyBuilder.new(@adapter)
    builder.include("my_path.js")
    builder.dependency_paths.should include("my_dependant_path.js")
  end
  
  it "should include non-direct dependant paths" do
    builder = Requirejs::DependencyBuilder.new(@adapter)
    builder.include("my_path.js")
    builder.dependency_paths.should include("my_other_dependant_path.js")
    builder.dependency_paths.should include("my_third_dependant_path.js")
  end
  
  it "should not request dependencies for path twice" do
    @adapter.stub(:direct_dependencies_for).with("my_path.js").once.and_return(["my_dependant_path.js"])
    @adapter.stub(:direct_dependencies_for).with("my_other_dependant_path.js").and_return(["my_path.js"])
    builder = Requirejs::DependencyBuilder.new(@adapter)
    builder.include("my_path.js")
    
  end
  
  it "should return cached dependecies" do
    
    @adapter.stub(:find_asset).with("my_path.js").and_return("stub_a")
    @adapter.stub(:find_asset).with("my_dependant_path.js").and_return("stub_b")
    @adapter.stub(:find_asset).with("my_other_dependant_path.js").and_return("stub_c")
     @adapter.stub(:find_asset).with("my_third_dependant_path.js").and_return("stub_d")
    
    builder = Requirejs::DependencyBuilder.new(@adapter)
    builder.include("my_path.js")
    
    
    builder.dependencies.sort.should eql(%w{ stub_a stub_b stub_c stub_d })
  end
  
  
  
  describe Requirejs::DependencyBuilder::SprocketsAdapter do 
    let(:asset) { stub }
    it "should find an asset path" do
      adapter = Requirejs::DependencyBuilder::SprocketsAdapter.new(stub(find_asset: asset))
      adapter.find_asset("my_path").should eql(asset)
    end
    
    it "should raise error if no dependency found" do
      sprockets = stub()
      adapter = Requirejs::DependencyBuilder::SprocketsAdapter.new(sprockets)
      sprockets.stub(:find_asset).with("my_path", bundle: false).and_return(nil)
      expect { adapter.direct_dependencies_for("my_path") }.to raise_error
    end
    

    it "should return dependncies" do
     
      asset = stub(:dependency_paths => [ stub(pathname: "dep_a"), stub(pathname:"dep_b")])
      sprockets = stub
      
      sprockets.stub(:find_asset).with("my_path", bundle: false).and_return(asset)
      sprockets.stub(:find_asset).with("dep_a", bundle: false).and_return(stub(logical_path: "path_a"))
      sprockets.stub(:find_asset).with("dep_b", bundle: false).and_return(stub(logical_path: "path_b"))
      
      
      
      adapter = Requirejs::DependencyBuilder::SprocketsAdapter.new(sprockets)
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
      
      
       adapter = Requirejs::DependencyBuilder::SprocketsAdapter.new(sprockets)
       adapter.direct_dependencies_for("my_path").should eql(["path_a"])
    end
    
  end
  
  
end