module Sprockets
  class Railtie < ::Rails::Railtie
    config.after_initialize do |app|
      Sprockets::Rails::Helper.precompile         = app.config.assets.precompile
      Sprockets::Rails::Helper.assets             = app.assets
      Sprockets::Rails::Helper.raise_asset_errors = app.config.assets.raise_production_errors
    end
  end
end
