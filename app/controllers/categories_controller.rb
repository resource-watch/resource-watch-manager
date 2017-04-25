# frozen_string_literal: true

# Controller for Categories
class CategoriesController < ApplicationController
  before_action :check_user_authentication if Rails.env.production?
  before_action :check_permissions if Rails.env.production?

  def index
    @categories = Category.all
  end

  def edit
    @category = Category.friendly.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    @category.save
    redirect_to categories_path
  end

  def update
    @category = Category.friendly.find(params[:id])
    @category.update(category_params)
    redirect_to categories_path
  end

  def destroy
    @category = Category.friendly.find(params[:id])
    if @category.destroy
      redirect_to categories_path, notice: 'Category successfully deleted'
    else
      redirect_to categories_path, notice: 'There was an error on deleting the Category'
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
