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
        return false unless Intro.config.enable

        return false unless request.get? && !request.xhr? && send(Intro.config.current_user_method)

        return true unless Intro.config.cache

        exist_tours = Intro.cache.read(controller_path, action_name)
        exist_tours || exist_tours.nil?
      end
    end
  end
end

ActionView::Base.include(Intro::Helpers::ViewHelper)