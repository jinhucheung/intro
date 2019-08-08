module Intro
  module Helpers
    module ViewHelper
      def intro_tag(options = {})
        return unless options[:enable] || enable_intro?

        intro_options = {
          controller: controller_path,
          action: action_name,
          original_url: request.original_url,
          tours_path: intro.tours_path,
          record_tours_path: intro.record_tours_path,
          locale: t('intro.tour'),
          shepherd_options: options[:shepherd] || {}
        }.freeze

        <<-HTML.html_safe
          #{tag(:meta, name: '_intro', data: intro_options)}
          #{javascript_include_tag('intro/application')}
          #{stylesheet_link_tag('intro/application')}
        HTML
      end

      def enable_intro?
        Intro.config.enable && request.get? && !request.xhr? && send(Intro.config.current_user_method)
      end
    end
  end
end

ActionView::Base.include(Intro::Helpers::ViewHelper)