module Intro
  module Helpers
    module ViewHelper
      def intro_tags(options = {})
        return unless options[:enable] || enable_intro?

        intro_options = {
          controller: controller_path,
          action: action_name,
          original_url: request.original_url,
          tours_path: intro.tours_path,
          record_tours_path: intro.record_tours_path,
          locales: t('intro.tour'),
          locale: I18n.locale,
          signed: !!send(Intro.config.current_user_method),
          shepherd_options: options[:shepherd] || {}
        }.freeze

        custom_assets = Intro.config.custom_assets_with_default
        custom_assets_tag = "#{javascript_pack_tag(custom_assets)} #{stylesheet_pack_tag(custom_assets)}" if custom_assets

        <<-HTML.html_safe
          <script>window._intro = #{ intro_options.to_json }</script>
          #{intro_webpacker_helper.javascript_pack_tag('intro/application')}
          #{intro_webpacker_helper.stylesheet_pack_tag('intro/application')}
          #{custom_assets_tag}
        HTML
      end

      def enable_intro?
        return false unless Intro.config.enable && request.get? && !request.xhr?

        return false unless Intro.config.visible_without_signing_in || send(Intro.config.current_user_method)

        return true unless Intro.config.cache

        exist_tours = Intro.cache.read(controller_path, action_name)
        exist_tours || exist_tours.nil?
      end

      def intro_webpacker_helper
        @intro_webpacker_helper ||= begin
          instance = self.dup
          instance.define_singleton_method(:current_webpacker_instance) do
            Intro.webpacker
          end
          instance
        end
      end
    end
  end
end

ActionView::Base.include(Intro::Helpers::ViewHelper)