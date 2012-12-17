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
    builder = Requirejs::DependencyBuilder.new(@adapter,stub)
    builder.include("my_path.js")
    builder.dependency_paths.should include("my_path.js")
  end
  
  it "should include direct dependant paths" do
    builder = Requirejs::DependencyBuilder.new(@adapter,stub)
    builder.include("my_path.js")
    builder.dependency_paths.should include("my_dependant_path.js")
  end
  
  it "should include non-direct dependant paths" do
    builder = Requirejs::DependencyBuilder.new(@adapter,stub)
    builder.include("my_path.js")
    builder.dependency_paths.should include("my_other_dependant_path.js")
    builder.dependency_paths.should include("my_third_dependant_path.js")
  end
  
  it "should not request dependencies for path twice" do
    @adapter.stub(:direct_dependencies_for).with("my_path.js").once.and_return(["my_dependant_path.js"])
    @adapter.stub(:direct_dependencies_for).with("my_other_dependant_path.js").and_return(["my_path.js"])
    builder = Requirejs::DependencyBuilder.new(@adapter,stub)
    builder.include("my_path.js")
    
  end
  
  it "should enumerate cached dependecies" do
    
    @adapter.stub(:find_asset).with("my_path.js").and_return("stub_a")
    @adapter.stub(:find_asset).with("my_dependant_path.js").and_return("stub_b")
    @adapter.stub(:find_asset).with("my_other_dependant_path.js").and_return("stub_c")
     @adapter.stub(:find_asset).with("my_third_dependant_path.js").and_return("stub_d")
    
    builder = Requirejs::DependencyBuilder.new(@adapter,stub)
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
  

 
  
  
end