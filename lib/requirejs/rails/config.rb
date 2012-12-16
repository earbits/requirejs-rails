require 'requirejs/rails'
require 'requirejs/error'

require 'requirejs/config/config_file'
require 'requirejs/config/build'
require 'requirejs/config/runtime'




require 'active_support/ordered_options'

require 'pathname'

module Requirejs::Rails
  class Config < ::ActiveSupport::OrderedOptions
    
    def initialize
      super
      self.manifest = nil

      self.logical_asset_filter = [/\.js$/,/\.html$/,/\.txt$/]
 
    
      self.follow_dependencies = false
      self.include_paths = true


      @config_file = Requirejs::Config::ConfigFile.new( ::Rails.root + "config/requirejs.yml")
    end


    

    def build
      
      @build_config ||= Requirejs::Config::Build.new(
                                {
                                  "modules" => [ { 'name' => 'application' } ],
                                  "manifest_path" => self.manifest_path,
                                  "follow_dependencies" => self.follow_dependencies,
                                  "logical_asset_filter" => self.logical_asset_filter
                                }.merge(@config_file.config),
                                ::Rails.root 
                        )
    end

    def runtime_config
      @runtime_config ||= Requirejs::Config::Runtime.new(
                                {
                                  "include_paths" =>  self.include_paths
                                }.merge @config_file.config
                          )
    end





    # def module_names
    #       self.build_config["modules"].map {|mod| mod["name"]}
    #     end
    #     
    
 

    
    def script_tags(main_module, options = {}, &block)
      Requirejs::Strategies::Requirejs.new(runtime_config, main_module, options, block).to_html
    end
  end
end
