require "requirejs/config/paths"

describe Requirejs::Config::Paths do
  
  let(:gem_root) { Pathname.new(__FILE__+'/../../../../..').cleanpath}
  subject(:config_paths) {Requirejs::Config::Paths.new(Pathname.new("/root"))}
  
  specify { config_paths.tmp.to_s.should eql("/root/tmp") }
  specify { config_paths.source.to_s.should eql("/root/tmp/assets") }
  specify { config_paths.target.to_s.should eql("/root/public/assets") }
  
  specify { config_paths.driver.to_s.should eql("/root/tmp/rjs_driver.js") }
  
  
  
  describe "gem relative paths" do
   
    subject(:path_class) {Requirejs::Config::Paths}
    
    its(:rjs_file) {should == gem_root + 'bin/r.js' }
    its(:driver_template) {should == gem_root + 'lib/requirejs/templates/rjs_driver.js.erb' }
    
    
    specify { config_paths.rjs_file.should eql(path_class.rjs_file) }
    specify { config_paths.driver_template.should eql(path_class.driver_template) }
    
    
  end


end