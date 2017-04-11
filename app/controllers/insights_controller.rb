# frozen_string_literal: true

# Static Pages Controller
class InsightsController < ApplicationController
  def index
    @insights = Insight.all
  end

  def new
    @insight = Insight.new
  end

  def show
    @insight = Insight.friendly.find(params[:id])
  end

  def edit
    @insight = Insight.friendly.find(params[:id])
  end

  def update
    @insight = Insight.friendly.find(params[:id])
    if @insight.update(insights_params)
      redirect_to insights_path, notice: 'Page updated successfully'
    else
      render :edit
    end
  end

  def create
    @insight = Insight.new(insights_params)
    if @insight.save
      redirect_to insights_path, notice: 'Page created successfully'
    else
      render :new
    end
  end

  def destroy
    @insight = Insight.friendly.find(params[:id])
    if @insight.destroy
      redirect_to insights_path, notice: 'Page destroyed successfully'
    else
      redirect_to insights_path, notice: 'Error on destroying page'
    end
  end

  private

  def insights_params
    params.require(:insight).permit(:title, :summary, :description, :content, :photo, :published)
  end
end
