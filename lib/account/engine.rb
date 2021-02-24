module Account
  class Engine < ::Rails::Engine
    isolate_namespace Account

    class<< self
      attr_accessor :custom_routes, :admin_modle_devise_setting
    end

    initializer 'account.asset_precompile_paths' do |app|
      # app.config.assets.precompile += ["shared/manifests/*"]
      app.config.assets.precompile += %w( account/application.js account/application.css )
    end

    initializer 'account.append_migrations' do |app|
      unless app.root.to_s == root.to_s
        config.paths["db/migrate"].expanded.each do |path|
          app.config.paths["db/migrate"].push(path)
        end
      end
    end

    initializer 'account.default_locale' do |app|
      app.config.i18n.default_locale = 'zh-CN'
    end

  end
end
