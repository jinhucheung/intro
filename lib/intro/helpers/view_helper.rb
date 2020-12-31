module Intro
  module Helpers
    module ViewHelper
      def intro_tags(options = {}, &block)
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

        intro_helper = self.dup
        intro_helper.define_singleton_method(:current_webpacker_instance) do
          Intro.webpacker
        end

        <<-HTML.html_safe
          <script>window._intro = #{ intro_options.to_json }</script>
          #{intro_helper.javascript_pack_tag('intro/application')}
          #{intro_helper.stylesheet_pack_tag('intro/application')}
          #{capture(&block) if block_given?}
        HTML
      end

      def enable_intro?
        return false unless Intro.config.enable && request.get? && !request.xhr?

        return false unless Intro.config.visible_without_signing_in || send(Intro.config.current_user_method)

        return true unless Intro.config.cache

        exist_tours = Intro.cache.read(controller_path, action_name)
        exist_tours || exist_tours.nil?
      end
    end
  end
end

ActionView::Base.include(Intro::Helpers::ViewHelper)