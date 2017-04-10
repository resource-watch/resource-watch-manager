# frozen_string_literal: true

# Controller for Subcategories
class SubcategoriesController < ApplicationController
  before_action :check_user_authentication if Rails.env.production?
  before_action :set_category

  def index
    @subcategories = @category.subcategories
  end

  def edit
    @datasets ||= Dataset.datasets
    @subcategory = @category.subcategories.friendly.find(params[:id])
  end

  def new
    @datasets ||= Dataset.datasets
    @subcategory = Subcategory.new category: @category
  end

  def create
    @subcategory = Subcategory.new(basic_subcategory_params)
    @subcategory.associate_datasets(dataset_subcategories_params)
    @subcategory.category = @category
    if @subcategory.save
      redirect_to category_subcategories_path(@category)
    else
      @datasets ||= Dataset.datasets
      render :new
    end
  end

  def update
    @subcategory = @category.subcategories.friendly.find(params[:id])
    @subcategory.assign_attributes(basic_subcategory_params)
    @subcategory.associate_datasets(dataset_subcategories_params)
    if @subcategory.save
      redirect_to category_subcategories_path(@category)
    else
      @datasets ||= Dataset.datasets
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
    # TODO: Change this when the ActiveModelAssociation supports Rails 5.1
    # params.require(:subcategory).permit(:name, :description, dataset_ids: [])
    params.require(:subcategory).permit(:name, :description, dataset_subcategories: [])
  end

  def basic_subcategory_params
    subcategory_params.except(:dataset_subcategories)
  end

  def dataset_subcategories_params
    subcategory_params[:dataset_subcategories]
  end

  def set_category
    @category = Category.friendly.find(params[:category_id])
  end
end
