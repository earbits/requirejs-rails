require 'requirejs/rails'
require 'requirejs/error'

require 'requirejs/config/config_file'


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


    
    def follow_dependencies=(val)
      self[:follow_dependencies] = val
    end

    def build_config
      
      @build_config ||= Requirejs::Config::Build.new(
                                {
                                  "baseUrl" =>  self.source_dir.to_s,
                                  "modules" => [ { 'name' => 'application' } ]
                              
                                }.merge @config_file.config,
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



    def module_name_for(mod)
   
        return mod['name']
    end

    def module_path_for(mod)
      self.target_dir+(module_name_for(mod)+'.js')
    end

    def module_names
      self.build_config["modules"].map {|mod| mod["name"]}
    end
    
    
    
    def get_binding
      return binding()
    end
    
    def source_path(path)
      (self.source_dir + path).cleanpath
    end

    def asset_allowed?(asset)
      self.logical_asset_filter.reduce(false) do |accum, matcher|
        accum || (matcher =~ asset)
      end ? true : false
    end
    
   
    

    
 
    
    def include_paths?
      self.include_paths
    end
    

    
    def script_tags(main_module, options = {}, &block)
      Requirejs::Strategies::Requirejs.new(runtime_config, main_module, options, block).to_html
    end
  end
end
