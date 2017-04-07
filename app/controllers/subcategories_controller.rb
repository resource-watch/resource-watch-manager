# frozen_string_literal: true

# Controller for Subcategories
class SubcategoriesController < ApplicationController
  before_action :check_user_authentication if Rails.env.production?
  before_action :set_category

  def index
    @subcategories = @category.subcategories
  end

  def edit
    @subcategory = @category.subcategories.friendly.find(params[:id])
  end

  def new
    @subcategory = Subcategory.new category: @category
  end

  def create
    @subcategory = Subcategory.new(subcategory_params)
    @subcategory.category = @category
    if @subcategory.save
      redirect_to category_subcategories_path(@category)
    else
      render :new
    end
  end

  def update
    @subcategory = @category.subcategories.friendly.find(params[:id])
    if @subcategory.update(subcategory_params)
      redirect_to category_subcategories_path(@category)
    else
      render :edit
    end
  end

  def destroy
    @subcategory = @category.subcategories.friendly.find(params[:id])
    if @subcategory.destroy
      redirect_to category_subcategories_path(@category),
                  notice: 'Subcategory successfully deleted'
    else
      redirect_to category_subcategories_path(@category),
                  notice: 'There was an error on deleting the Subcategory'
    end
  end

  private

  def subcategory_params
    params.require(:subcategory).permit(:name, :description)
  end

  def set_category
    @category = Category.friendly.find(params[:category_id])
  end
end
