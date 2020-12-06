module Account
  class Engine < ::Rails::Engine
    isolate_namespace Account

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

  end
end
