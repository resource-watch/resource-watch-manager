# frozen_string_literal: true

module Api
  # API class for the Faqs Resource
  class FaqsController < ApiController
    before_action :set_faq, only: %i[show update destroy]

    def index
      render json: Faq.all
    end

    def show
      render json: @faq
    end

    def create
      faq = Faq.new(faq_params)
      if faq.save
        render json: faq, status: :created
      else
        render_error(faq, :unprocessable_entity)
      end
    end

    def update
      if @faq.update_attributes(faq_params)
        render json: @faq, status: :ok
      else
        render_error(@faq, :unprocessable_entity)
      end
    end

    def destroy
      @faq.destroy
      head 204
    end

    def reorder
      Faq.reorder(params[:ids])
      render json: Faq.all
    rescue Exception => e
      faq = Faq.new
      faq.errors.add(:id, e.message)
      render_error(faq, :unprocessable_entity)
    end

    private

    def set_faq
      @faq = Faq.find params[:id]
    rescue ActiveRecord::RecordNotFound
      faq = Faq.new
      faq.errors.add(:id, 'Wrong ID provided')
      render_error(faq, 404) && return
    end

    def faq_params
      ParamsHelper.permit(params, :question, :answer, :order)
    rescue
      nil
    end
  end
end
