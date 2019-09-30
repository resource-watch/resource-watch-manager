# frozen_string_literal: true

# app/controllers/concerns/duplicable.rb
module Duplicable
  extend ActiveSupport::Concern

  module ClassMethods
  end

  def clone_widgets(user_id = nil)
    widget_list = obtain_widget_list(content)
    create_widgets(widget_list, user_id)
  end

  def obtain_widget_list(content)
    widgets_list = content.scan(/widgetId":"([^"]*)","datasetId":"([^"]*)"/)
    widgets_list.map { |w| {widget_id: w.first, dataset_id: w.last} }.uniq
  end

  def create_widgets(widgets_list, user_id = nil)
    new_widgets_list = []
    widgets_list.each do |widget|
      new_widget_id = WidgetService.clone(widget[:widget_id], widget[:dataset_id], user_id)
      new_widgets_list << { old_id: widget[:widget_id], new_id: new_widget_id }
    end
    new_widgets_list
  end

  def clone_model(widgets = [])
    new_model = self.dup
    new_content = self.content
    widgets.each { |x| new_content.gsub!(x[:old_id], x[:new_id]) }
    new_model.content = new_content
    new_model.save
    new_model
  end

  def clone_to(new_class, widgets = [], user_id = nil)
    new_model = new_class.new
    new_model.attributes = self.attributes.except 'id', 'updated_at', 'created_at'
    new_content = self.content
    widgets.each { |x| new_content.gsub!(x[:old_id], x[:new_id]) }
    new_model.content = new_content
    new_model.user_id = user_id if user_id
    new_model.save
    new_model
  end
end
