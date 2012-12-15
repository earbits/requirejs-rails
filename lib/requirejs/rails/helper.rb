require "action_view"
require "sprockets"

require "requirejs/strategies/requirejs"
module Requirejs
  module Rails
    module Helper
      extend ActiveSupport::Concern
      include ActionView::Helpers::AssetTagHelper
      
      def requirejs_include_tag(main_module, options = {})
        rjs_config = ::Rails.application.config.requirejs
        options.merge!( { use_digest: !!::Rails.application.config.assets.digest} )
        
        
        rjs_config.script_tags(main_module, options) do |path|
          javascript_path(path)
        end.html_safe
      end
    end
  end
end