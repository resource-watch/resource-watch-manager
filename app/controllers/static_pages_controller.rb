# frozen_string_literal: true

# Static Pages Controller
class StaticPagesController < ApplicationController
  def index
    @static_pages = StaticPage.all
  end

  def new
    @static_page = StaticPage.new
  end

  def show
    @static_page = StaticPage.friendly.find(params[:id])
  end

  def edit
    @static_page = StaticPage.friendly.find(params[:id])
  end

  def update
    @static_page = StaticPage.friendly.find(params[:id])
    if @static_page.update(static_pages_params)
      redirect_to static_pages_path, notice: 'Page updated successfully'
    else
      render :edit
    end
  end

  def create
    @static_page = StaticPage.new(static_pages_params)
    if @static_page.save
      redirect_to static_pages_path, notice: 'Page created successfully'
    else
      render :new
    end
  end

  def destroy
    @static_page = StaticPage.friendly.find(params[:id])
    if @static_page.destroy
      redirect_to static_pages_path, notice: 'Page destroyed successfully'
    else
      redirect_to static_pages_path, notice: 'Error on destroying page'
    end
  end

  private

  def static_pages_params
    params.require(:static_page).permit(:title, :summary, :description, :content, :photo, :published)
  end
end
