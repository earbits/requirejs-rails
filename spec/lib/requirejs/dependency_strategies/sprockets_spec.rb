require "requirejs/dependency_strategies/sprockets"
describe Requirejs::DependencyStrategies::Sprockets do

  before do
    @adapter = stub
    @adapter.stub(:direct_dependencies_for).with("my_path.js").and_return(["my_dependant_path.js"])
    @adapter.stub(:direct_dependencies_for).with("my_dependant_path.js").and_return(["my_other_dependant_path.js", "my_third_dependant_path.js"])
    @adapter.stub(:direct_dependencies_for).with("my_other_dependant_path.js").and_return([])
      @adapter.stub(:direct_dependencies_for).with("my_third_dependant_path.js").and_return([])
  end
  it "should include a give path as a dependency" do
    builder = Requirejs::DependencyStrategies::Sprockets.new(@adapter,stub)
    builder.include("my_path.js")
    builder.dependency_paths.should include("my_path.js")
  end
  
  it "should include direct dependant paths" do
    builder = Requirejs::DependencyStrategies::Sprockets.new(@adapter,stub)
    builder.include("my_path.js")
    builder.dependency_paths.should include("my_dependant_path.js")
  end
  
  it "should include non-direct dependant paths" do
    builder = Requirejs::DependencyStrategies::Sprockets.new(@adapter,stub)
    builder.include("my_path.js")
    builder.dependency_paths.should include("my_other_dependant_path.js")
    builder.dependency_paths.should include("my_third_dependant_path.js")
  end
  
  it "should not request dependencies for path twice" do
    @adapter.stub(:direct_dependencies_for).with("my_path.js").once.and_return(["my_dependant_path.js"])
    @adapter.stub(:direct_dependencies_for).with("my_other_dependant_path.js").and_return(["my_path.js"])
    builder = Requirejs::DependencyStrategies::Sprockets.new(@adapter,stub)
    builder.include("my_path.js")
    
  end
  
  it "should enumerate cached dependecies" do
    
    @adapter.stub(:find_asset).with("my_path.js").and_return("stub_a")
    @adapter.stub(:find_asset).with("my_dependant_path.js").and_return("stub_b")
    @adapter.stub(:find_asset).with("my_other_dependant_path.js").and_return("stub_c")
     @adapter.stub(:find_asset).with("my_third_dependant_path.js").and_return("stub_d")
    
    builder = Requirejs::DependencyStrategies::Sprockets.new(@adapter,stub)
    builder.include("my_path.js")
    
    dependencies = []
    builder.each do |j|
      dependencies << j
    end
    
    
    dependencies.should include("my_path.js")
    dependencies.should include("my_dependant_path.js")
    dependencies.should include("my_other_dependant_path.js")
    dependencies.should include("my_third_dependant_path.js")
  end
  
  
  class TestAdapter
    def direct_dependencies_for(path, &block)
      block.call(<<-JS
        define(["defined"], function() {});
      JS
      )
    end
  end
  it "should parse dependant body" do
    config = stub
    config.stub(:map_module_name).with("defined").and_return("defined")
    builder = Requirejs::DependencyStrategies::Sprockets.new(TestAdapter.new, config)
    builder.include("to_parse.js")
    builder.dependency_paths.should include("defined.js")
  end
  it "should parse dependant body and map module names" do
    config = stub
    config.stub(:map_module_name).with("defined").and_return("mapped_define")
    
    builder = Requirejs::DependencyStrategies::Sprockets.new(TestAdapter.new, config)
    builder.include("to_parse.js")
    builder.dependency_paths.should include("mapped_define.js")
  end
  
  
  describe Requirejs::DependencyStrategies::Sprockets::Adapter do 
    let(:asset) { stub }
    it "should find an asset path" do
      adapter = Requirejs::DependencyStrategies::Sprockets::Adapter.new(stub(find_asset: asset))
      adapter.find_asset("my_path").should eql(asset)
    end
    
    it "should raise error if no dependency found" do
      sprockets = stub()
      adapter = Requirejs::DependencyStrategies::Sprockets::Adapter.new(sprockets)
      sprockets.stub(:find_asset).with("my_path", bundle: false).and_return(nil)
      expect { adapter.direct_dependencies_for("my_path") }.to raise_error
    end
    

    it "should return dependncies" do
     
      asset = stub(:dependency_paths => [ stub(pathname: "dep_a"), stub(pathname:"dep_b")])
      sprockets = stub
      
      sprockets.stub(:find_asset).with("my_path", bundle: false).and_return(asset)
      sprockets.stub(:find_asset).with("dep_a", bundle: false).and_return(stub(logical_path: "path_a"))
      sprockets.stub(:find_asset).with("dep_b", bundle: false).and_return(stub(logical_path: "path_b"))
      
      
      
      adapter = Requirejs::DependencyStrategies::Sprockets::Adapter.new(sprockets)
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
      
      
       adapter = Requirejs::DependencyStrategies::Sprockets::Adapter.new(sprockets)
       adapter.direct_dependencies_for("my_path").should eql(["path_a"])
    end
    
    it "should allow a block to extract dependencies from body" do
      sprockets = stub
      file = stub(pathname: "my_path")
      asset = stub(:dependency_paths => [file], logical_path: "path_a", body: "file body")
      sprockets.stub(:find_asset).with("my_path", bundle: false).and_return(asset)
      
      adapter = Requirejs::DependencyStrategies::Sprockets::Adapter.new(sprockets)
      dependancies = adapter.direct_dependencies_for("my_path") do |body|
        body.should eql("file body")
        ['extracted_path']
      end
      dependancies.should include("path_a")
      dependancies.should include("extracted_path")
    end
  end
  
  
end