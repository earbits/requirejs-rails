
require 'pathname'

module Requirejs
  module Config
    class Paths
      def initialize(root_path)
        @root_path = root_path
      end
      
      
      def tmp
        @root_path + 'tmp'
      end
      
      def source
        self.tmp + 'assets'
      end
      
      def driver
        self.tmp + "rjs_driver.js"
      end
            
      def target
        @root_path + 'public/assets'
      end
      
      def output_for(logical_path)
        self.target + logical_path
      end
      
      def rjs_file
        self.class.rjs_file
      end
      
      def driver_template
        self.class.driver_template
      end
      
      
      ## gem relative
      def self.gem_root
        Pathname.new(__FILE__+'/../../../..').cleanpath
      end
      
      def self.rjs_file
        gem_root + 'bin/r.js'
      end
      
      def self.driver_template
        gem_root + 'lib/requirejs/templates/rjs_driver.js.erb' 
      end
      
      
  
    end
  end
end