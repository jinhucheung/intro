module Intro
  class Engine < ::Rails::Engine
    isolate_namespace Intro

    # use packs from intro via Rack static
    # file service, to enable webpacker to find them
    # when running in the host application
    config.app_middleware.use(
      Rack::Static,
      # note! this varies from the webpacker/engine documentation
      urls: ["/intro-packs"], root: Intro::Engine.root.join("public")
    )

    # conflict in engine and root app
    #
    # initializer "webpacker.proxy" do |app|
    #   insert_middleware = begin
    #     Intro.webpacker.config.dev_server.present?
    #   rescue
    #     nil
    #   end
    #   next unless insert_middleware

    #   app.middleware.insert_before(
    #     0, Webpacker::DevServerProxy, # "Webpacker::DevServerProxy" if Rails version < 5
    #     ssl_verify_none: true,
    #     webpacker: Intro.webpacker
    #   )
    # end
  end
end
