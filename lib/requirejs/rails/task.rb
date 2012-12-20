require 'rake'
require 'rake/tasklib'

require 'requirejs/rails/builder'
require 'requirejs/rails/config'
require "requirejs/dependency_builder"
require "requirejs/adapters/sprockets"
require "requirejs/adapters/sprockets_amd"


require 'fileutils'
require 'pathname'

require 'sprockets'
require 'tempfile'

require 'active_support/ordered_options'
module Requirejs
  module Rails
    class Task < Rake::TaskLib
      
      def initialize(name = :requirejs)
        yield self if block_given?
           define
         end
      def define
        namespace :requirejs do

          # From Rails 3 assets.rake; we have the same problem:
          #
          # We are currently running with no explicit bundler group
          # and/or no explicit environment - we have to reinvoke rake to
          # execute this task.
          def invoke_or_reboot_rake_task(task)
            if ENV['RAILS_GROUPS'].to_s.empty? || ENV['RAILS_ENV'].to_s.empty?
              ruby_rake_task task
            else
              Rake::Task[task].invoke
            end
          end

          requirejs = ActiveSupport::OrderedOptions.new

          task :clean => ["requirejs:setup"] do
            FileUtils.remove_entry_secure(requirejs.build_config.paths.source, true)
            FileUtils.remove_entry_secure(requirejs.build_config.paths.driver, true)
          end

          task :setup => ["assets:environment"] do
            unless ::Rails.application.config.assets.enabled
              warn "Cannot precompile assets if sprockets is disabled. Please set config.assets.enabled to true"
              exit
            end

            # Ensure that action view is loaded and the appropriate
            # sprockets hooks get executed
            _ = ActionView::Base

            requirejs.env = ::Rails.application.assets

            # Preserve the original asset paths, as we'll be manipulating them later
            requirejs.env_paths = requirejs.env.paths.dup
            requirejs.build_config = ::Rails.application.config.requirejs.build
            requirejs.builder = Requirejs::Rails::Builder.new(requirejs.build_config)
            requirejs.manifest = {}
          end

          task :test_node do
            begin
              `node -v`
            rescue Errno::ENOENT
              STDERR.puts <<-EOM
        Unable to find 'node' on the current path, required for precompilation
        using the requirejs-ruby gem. To install node.js, see http://nodejs.org/
        OS X Homebrew users can use 'brew install node'.
        EOM
              exit 1
            end
          end

          namespace :precompile do
            task :all => ["requirejs:precompile:prepare_source",
                          "requirejs:precompile:generate_rjs_driver",
                          "requirejs:precompile:run_rjs",
                          "requirejs:precompile:digestify_and_compress",
                          "requirejs:clean"]

            task :disable_js_compressor do
              # Ensure that Sprockets doesn't try to compress assets before they hit
              # r.js.  Failure to do this can cause a build which works in dev, but
              # emits require.js "notloaded" errors, etc. in production.
              ::Rails.application.config.assets.js_compressor = false
            end

            # Invoke another ruby process if we're called from inside
            # assets:precompile so we don't clobber the environment
            #
            # We depend on test_node here so we'll fail early and hard if node
            # isn't available.
            task :external => ["requirejs:test_node"] do
              ruby_rake_task "requirejs:precompile:all"
            end

            # copy all assets to tmp/assets
            task :prepare_source => ["requirejs:setup",
                                     "requirejs:clean"] do
              requirejs.build_config.paths.source.mkpath
      
              if requirejs.build_config.follow_dependencies?
                ## User depend_on and require directioves to identify 
                ## assets to copy over as source
        
                #adapter = Requirejs::Adapters::Sprockets.new(requirejs.env)
                adapter = Requirejs::Adapters::SprocketsAmd.new(requirejs.env, requirejs.build_config)
                builder = Requirejs::DependencyBuilder.new(adapter)
        
                ## seed assets based off of module names
                requirejs.build_config.module_names.each do |mod_name|
                  builder.include(mod_name + ".js")
                end
      
                ## copy assets
                builder.each do |logical_path|
                  next unless requirejs.build_config.asset_allowed?(logical_path)
       
                  asset = adapter.find_asset(logical_path)  
          
                  filename = requirejs.build_config.paths.source + asset.logical_path
                  filename.dirname.mkpath
                  asset.write_to(filename)
                end
        
              else
                ## Copy all allowable assets as source
                requirejs.env.each_logical_path do |logical_path|
                  next unless requirejs.build_config.asset_allowed?(logical_path)
                  if asset = requirejs.env.find_asset(logical_path)
                    filename = requirejs.build_config.paths.source + asset.logical_path
                    filename.dirname.mkpath
                    asset.write_to(filename)
                  end
                end
        
              end
      
            end

            task :generate_rjs_driver => ["requirejs:setup"] do
              requirejs.builder.generate_rjs_driver
            end

            task :run_rjs => ["requirejs:setup",
                              "requirejs:test_node"] do
              requirejs.build_config.paths.target.mkpath

              `node "#{requirejs.build_config.paths.driver}"`
              unless $?.success?
                raise RuntimeError, "Asset compilation with node failed."
              end
            end

            # Copy each built asset, identified by a named module in the
            # build config, to its Sprockets digestified name.
            task :digestify_and_compress => ["requirejs:setup"] do
              requirejs.build_config.modules.each do |m|
                asset_name = "#{m.name}.js"
                built_asset_path = requirejs.build_config.paths.target + asset_name
                digest_name = asset_name.sub(/\.(\w+)$/) { |ext| "-#{requirejs.builder.digest_for(built_asset_path)}#{ext}" }
                digest_asset_path = requirejs.build_config.paths.target + digest_name
                requirejs.manifest[asset_name] = digest_name
                FileUtils.cp built_asset_path, digest_asset_path

                # Create the compressed versions
                File.open("#{built_asset_path}.gz",'wb') do |f|
                  zgw = Zlib::GzipWriter.new(f, Zlib::BEST_COMPRESSION)
                  zgw.write built_asset_path.read
                  zgw.close
                end
                FileUtils.cp "#{built_asset_path}.gz", "#{digest_asset_path}.gz"

                requirejs.build_config.manifest_path.open('wb') do |f|
                  YAML.dump(requirejs.manifest,f)
                end
              end
            end
          end

          desc "Precompile RequireJS-managed assets"
          task :precompile do
            invoke_or_reboot_rake_task "requirejs:precompile:all"
          end
        end

        task "assets:precompile" => ["requirejs:precompile:external"]
        if ARGV[0] == "requirejs:precompile:all"
          task "assets:environment" => ["requirejs:precompile:disable_js_compressor"]
        end
      end
    end
  end
end
