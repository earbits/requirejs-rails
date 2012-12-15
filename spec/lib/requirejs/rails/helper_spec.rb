#require "active_support/core_ext/module/attribute_accessors"
require 'action_view'
require "requirejs/rails/helper"

describe Requirejs::Rails::Helper do
  ASSETS_PATH = File.expand_path("../assets", __FILE__)
  
  before do
    @view = ActionView::Base.new
    @view.extend ::Requirejs::Rails::Helper
    #@view.assets_prefix = "/assets"
  end

  describe "#requirejs_include_tag" do
    
    specify { @view.requirejs_include_tag}
    specify { @view.config.should eql({})}
    it "should render a requirejs script tag"
     # do
     #      helper.requirejs_include_tag.should eql("A")
     #    end
     #    
    it "should render a require config tag if requirejs.yml present"
  end
end