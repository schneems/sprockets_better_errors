module Sprockets::Rails::Helper

  # == BEGIN Hacks for checking if dependencies are listed correctly
  class DependencyError <StandardError
    def initialize(path, dep)
      msg =  "Asset depends on '#{dep}' to generate properly but has not declared the dependency\n"
      msg << "Please add: `//= depend_on_asset \"#{dep}\"` to '#{path}'"
      super msg
    end
  end


  def check_dependencies!(dep)
    return unless @_dependency_assets
    return if     @_dependency_assets.detect { |asset| asset.include?(dep) }
    raise DependencyError.new(self.pathname, dep)
  end

  alias :orig_compute_asset_path :compute_asset_path
  def compute_asset_path(path, options = {})
    check_dependencies!(path)
    orig_compute_asset_path(path, options)
  end

  # == BEGIN Hacks for checking if asset is in precompile list

  # support for Ruby 1.9.3 Rails 3.x
  @_config = ActiveSupport::InheritableOptions.new({}) unless defined?(ActiveSupport::Configurable::Configuration)
  include ActiveSupport::Configurable
  config_accessor :precompile, :assets, :raise_asset_errors

  class AssetNotPresentError < StandardError
    def initialize(source)
      msg = "Asset not present: " <<
            "could not find '#{source}' in any asset directory"
      super(msg)
    end
  end

  class AssetFilteredError < StandardError
    def initialize(source)
      msg = "Asset filtered out and will not be served: " <<
            "add `config.assets.precompile += %w( #{source} )` " <<
            "to `config/application.rb` and restart your server"
      super(msg)
    end
  end


  alias :orig_asset_path :asset_path
  def asset_path(source, options = {})
    check_errors_for(source)
    path_to_asset(source, options)
  end

  alias :orig_javascript_include_tag :javascript_include_tag
  def javascript_include_tag(*args)
    sources = args.dup
    sources.extract_options!
    sources.map do |source|
      check_errors_for(source)
    end
    orig_javascript_include_tag(*args)
  end

  alias :orig_stylesheet_link_tag :stylesheet_link_tag
  def stylesheet_link_tag(*args)
    sources = args.dup
    sources.extract_options!
    sources.map do |source|
      check_errors_for(source)
    end
    orig_stylesheet_link_tag(*args)
  end

  protected
    # Raise errors when source does not exist or is not in the precomiled list
    def check_errors_for(source)
      return source unless Sprockets::Rails::Helper.raise_asset_errors
      return source if ["all", "defaults"].include?(source.to_s)
      return ""     if source.blank?
      return source if source =~ URI_REGEXP

      asset = lookup_asset_for_path(source)
      raise AssetNotPresentError.new(source) if asset.blank?
      raise AssetFilteredError.new(source)   if asset_needs_precompile?(source, asset.pathname.to_s)
    end

    # Returns true when an asset will not available after precompile is run
    def asset_needs_precompile?(source, filename)
      return true  unless Sprockets::Rails::Helper.assets
      return false if Sprockets::Rails::Helper.assets.send(:matches_filter, Sprockets::Rails::Helper.precompile || [], source, filename)
      true
    end
end
