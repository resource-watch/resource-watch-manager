# frozen_string_literal: true

module Api
  module V1
    # API class for the Static Pages Resource
    class AppsController < ApiController
      include Orderable

      before_action :set_app, only: %w[show destroy update]

      def index
        @apps = App.order(ordering_params(params))
        paginate json: @apps, each_serializer: AppSerializer
      end

      def create
        @app = App.new(app_params)
        if @app.save
          render json: { messages: [{ status: 201, title: 'App successfully created!' }] },
                 status: 201
        else
          render json: ErrorSerializer.serialize(@app.errors, 422), status: 422
        end
      end

      def destroy
        if @app.destroy
          render json: { messages: [{ status: 201, title: 'App successfully destroyed!' }] },
                 status: 200
        else
          render json: ErrorSerializer.serialize(@app.errors, 422), status: 422
        end
      end

      def update
        if @app.update(app_params)
          render json: { messages: [{ status: 200, title: 'App successfully updated!' }] },
                 status: 200
        else
          render json: ErrorSerializer.serialize(@app.errors, 422), status: 422
        end
      end

      def show
        render json: @app, serializer: AppSerializer
      end

      private

      def set_app
        @app = App.find(params[:id])
      end

      def app_params
        params.require(:app).permit(:id, :name, :description, :body, :technical_details, :author,
                                    :web_url, :ios_url, :image_base)
      end
    end
  end
end