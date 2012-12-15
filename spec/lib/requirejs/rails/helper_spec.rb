require "rails"
require "requirejs/rails/helper"
require "active_support/core_ext/object/to_json"

describe Requirejs::Rails::Helper do
  ASSETS_PATH = File.expand_path("../assets", __FILE__)
  
  before do
    @view = ActionView::Base.new
    @view.extend ::Requirejs::Rails::Helper
    @view.config.assets_dir = "/assets"
  end

  class ConfigHelper
    def script_tags(main_module, options, &block)
      "<script data-main='#{block.call(main_module)}' src='#{block.call("require")}'></script>"
    end
  end
  
  describe "#requirejs_include_tag" do
    

    it "should render a script tag" do
      ::Rails.application = stub(config: stub(requirejs: ConfigHelper.new, assets: stub(digest: false)))
       @view.requirejs_include_tag("my_module").should  eql("<script data-main='/javascripts/my_module.js' src='/javascripts/require.js'></script>")
    end
      it "should render an html safe tag" do
        ::Rails.application = stub(config: stub(requirejs: ConfigHelper.new, assets: stub(digest: false)))
         @view.requirejs_include_tag("my_module").should be_html_safe
      end
    it "shoudl pass user options" do
      config = stub
      config.should_receive(:script_tags).with("my_module", {use_digest: true}).and_return(stub(:html_safe => true))
      ::Rails.application = stub(config: stub(requirejs: config, assets: stub(digest: true)))
      @view.requirejs_include_tag("my_module")
    end
   
  end
end