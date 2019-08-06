module Intro
  module Admin
    class ImagesController < ::Intro::Admin::ApplicationController
      if Rails::VERSION::MAJOR > 3
        before_action :authenticate
        before_action :require_image, only: :create
      else
        before_filter :authenticate
        before_filter :require_image, only: :create
      end

      def create
        uploader = Intro::ImageUploader.new

        uploader.cache!(params[:image])
        uploader.store!

        render json: { data: { url: uploader.url } }
      end

      protected

      def require_image
        params[:image].nil? && respond_to do |format|
          format.json { render json: { message: t('intro.errors.require_image') }, status: :bad_request }
          format.any  { head :bad_request  }
        end
      end
    end
  end
end