module Intro
  class Engine < ::Rails::Engine
    isolate_namespace Intro

    initializer 'webpacker.proxy' do |app|
      insert_middleware = begin
                            Intro.webpacker.config.dev_server.present?
                          rescue
                            nil
                          end
      next unless insert_middleware

      app.middleware.insert_before(
        0, Webpacker::DevServerProxy, # "Webpacker::DevServerProxy" if Rails version < 5
        ssl_verify_none: true,
        webpacker: Intro.webpacker
      )
    end

    config.app_middleware.use(
      Rack::Static,
      urls: ['/intro-packs'], root: 'intro/public'
    )
  end
end
