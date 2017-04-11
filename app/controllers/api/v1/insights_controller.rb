# frozen_string_literal: true

module Api
  module V1
    # API class for the Static Pages Resource
    class InsightsController < ApiController
      def index
        insights = Insight.where(published: true)
        render json: insights
      end

      def show
        render json: Insight.friendly.find(params[:id])
      end
    end
  end
end