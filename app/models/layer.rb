# frozen_string_literal: true

# Mock class for the API's layers
class Layer
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :id, :slug, :user_id, :name, :default, :iso,
                :description, :layer_config, :legend_config, :application_config, :static_image_config

  def initialize(data= {})
    self.attributes = data unless data == {}
  end

  def attributes
    {
      id: @id,
      slug: @slug,
      user_id: @user_id,
      name: @name,
      default: @default,
      iso: @iso,
      description: @description,
      layer_config: @layer_config,
      legend_config: @legend_config,
      application_config: @application_config,
      static_image_config: @static_image_config
    }
  end

  def attributes=(data)
    return unless data && (data[:attributes] || data['attributes'])
    data.symbolize_keys!
    data[:attributes].symbolize_keys!
    @id = data[:id]
    @name = data[:attributes][:name]
    @slug = data[:attributes][:slug]
    @user_id = data[:attributes][:userId]
    @default = data[:attributes][:default]
    @iso = data[:attributes][:iso]
    @layer_config = data[:attributes][:layerConfig]
    @legend_config = data[:attributes][:legendConfig]
    @application_config = data[:attributes][:applicationConfig]
    @static_image_config = data[:attributes][:staticImageConfig]
  end
end