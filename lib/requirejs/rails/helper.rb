require "action_view"
module Requirejs
  module Rails
    module Helper
      extend ActiveSupport::Concern
      include ActionView::Helpers::AssetTagHelper
      
      def requirejs_include_tag
        
      end
      
      protected
      
      def requirejs_config
        
      end
    end
  end
end