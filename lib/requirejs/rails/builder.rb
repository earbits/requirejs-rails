require 'requirejs/rails'

require 'pathname'
require 'ostruct'

require 'erubis'

module Requirejs::Rails
  class Builder
    # config should be an instance of Requirejs::Config::Build
    
    def initialize(config)
      @config = config
    end
    
    def build      
      @config.paths.tmp
    end

    def digest_for(path)
      Rails.application.assets.file_digest(path).hexdigest
    end

    def generate_rjs_driver
      templ = Erubis::Eruby.new(@config.paths.driver_template.read)
      @config.paths.driver.open('w') do |f|
        f.write(templ.result(@config.get_binding))
      end
    end
  end
end