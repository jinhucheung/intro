module Intro
  class Cache
    class << self
      def write(controller, action, value)
        Rails.cache.write(cache_token(controller, action), value)
      end

      def read(controller, action)
        Rails.cache.read(cache_token(controller, action))
      end

      def delete(controller, action)
        Rails.cache.delete(cache_token(controller, action))
      end

      private

      def cache_token(controller, action)
        "intro-#{controller}-#{action}".freeze
      end
    end
  end
end