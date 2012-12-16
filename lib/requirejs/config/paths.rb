
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
      
      
      #elf.driver_template_path = Pathname.new(__FILE__+'/../rjs_driver.js.erb').cleanpath
      #self.driver_path = self.tmp_dir + 'rjs_driver.js'
      
      # self.tmp_dir = 
      # 
      # 
      #      self.source_dir = self.tmp_dir + 'assets'
      #      self.target_dir = ::Rails.root + 'public/assets'
      # 
      #      self.bin_dir = Pathname.new(__FILE__+'/../../../../bin').cleanpath
      #      self.rjs_path   = self.bin_dir+'r.js'
      #     
    end
  end
end