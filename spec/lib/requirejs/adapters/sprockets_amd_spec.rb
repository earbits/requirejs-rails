require "requirejs/adapters/sprockets_amd"
describe Requirejs::Adapters::SprocketsAmd do
  
  # 
  # it "should parse dependant body" do
  #   config = stub
  #   config.stub(:map_module_name).with("defined").and_return("defined")
  #   builder = Requirejs::DependencyBuilder.new(TestAdapter.new, config)
  #   builder.include("to_parse.js")
  #   builder.dependency_paths.should include("defined.js")
  # end
  # it "should parse dependant body and map module names" do
  #   config = stub
  #   config.stub(:map_module_name).with("defined").and_return("mapped_define")
  #   
  #   builder = Requirejs::DependencyBuilder.new(TestAdapter.new, config)
  #   builder.include("to_parse.js")
  #   builder.dependency_paths.should include("mapped_define.js")
  # end
  # 
  
    
    # it "should allow a block to extract dependencies from body" do
    #   sprockets = stub
    #   file = stub(pathname: "my_path")
    #   asset = stub(:dependency_paths => [file], logical_path: "path_a", body: "file body")
    #   sprockets.stub(:find_asset).with("my_path", bundle: false).and_return(asset)
    #   
    #   adapter = Requirejs::Adapters::Sprockets.new(sprockets)
    #   dependancies = adapter.direct_dependencies_for("my_path") do |body|
    #     body.should eql("file body")
    #     ['extracted_path']
    #   end
    #   dependancies.should include("path_a")
    #   dependancies.should include("extracted_path")
    # end
end