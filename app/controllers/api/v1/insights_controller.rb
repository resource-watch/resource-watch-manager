# frozen_string_literal: true

module Api
  module V1
    # API class for the Static Pages Resource
    class InsightsController < ApiController
      include Orderable

      before_action :set_insight, only: %w[show destroy update]

      def index
        @insights = Insight.published.order(ordering_params(params))
        paginate json: @insights, each_serializer: InsightSerializer
      end

      def create
        @insight = Insight.new(insight_params)
        if @insight.save
          render json: { messages: [{ status: 201, title: 'Insight successfully created!' }] },
                 status: 201
        else
          render json: ErrorSerializer.serialize(@insight.errors, 422), status: 422
        end
      end

      def destroy
        if @insight .destroy
          render json: { messages: [{ status: 201, title: 'Insight successfully destroyed!' }] },
                 status: 200
        else
          render json: ErrorSerializer.serialize(@insight.errors, 422), status: 422
        end
      end

      def update
        if @insight.update(insight_params)
          render json: { messages: [{ status: 200, title: 'Insight successfully updated!' }] },
                 status: 200
        else
          render json: ErrorSerializer.serialize(@insight.errors, 422), status: 422
        end
      end

      def show
        render json: @insight, serializer: InsightSerializer
      end

      private

      def set_insight
        @insight = Insight.friendly.find(params[:id])
      end

      def insight_params
        params.require(:insight).permit(:title, :summary, :description, :content, :published, :photo)
      end
    end
  end
end