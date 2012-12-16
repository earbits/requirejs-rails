#require "rails"

require "requirejs/rails/config"
describe Requirejs::Rails::Config do 
  module Rails; end unless defined?(Rails)
  before do 
    ::Rails.stub(root: Pathname.new("/root"))
  end

  describe "defaults" do
    it { should respond_to :manifest}
  
    it {should respond_to :logical_asset_filter}
  
  
    its(:follow_dependencies) {should eql(false)}
    its(:include_paths) {should eql(true)}
  end
  
  let(:config) {Requirejs::Rails::Config.new}
  
  it "should allow follow dependencies to be set" do
    config.follow_dependencies = true
    config.follow_dependencies.should be_true
  end
end