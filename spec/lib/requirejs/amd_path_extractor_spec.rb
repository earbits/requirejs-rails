require "requirejs/amd_path_extractor"
describe Requirejs::AmdPathExtractor do
 
  subject(:extracted_dependencies)  do
     Requirejs::AmdPathExtractor.parse( <<-JS
    
        //=depend_on common/vendor/date
        console.log("LOADING loader")

        define([
          'jquery',
          'common/vendor/sha1',
          ], function () {
          console.log("CALLING loader")
          // This is a comment
          
          require(['app'], function () {
               
          });
          require();
          return;
        });
        
        define();
        define(['exports','module','require']);
        define(['plugin!']);
    
    JS
    )
  end
  
  
    
  it { should include('jquery') }
  it { should include('common/vendor/sha1') }
  it { should include('app') }
  
  describe "reserve words" do
    
    it { should_not include('exports') }
    it { should_not include('module') }
    it { should_not include('require') }
  end
  
  describe "plugins" do
    
    it { should_not include('plugin!') }
    it { should include('plugin') }
  end

end