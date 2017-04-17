# frozen_string_literal: true

# Mock class for the API's datasets
class Dataset

  # The Model is a mixin for Naming, Translation, Validations and Conversions
  include ActiveModel::Model
  include ActiveModel::Serialization
  #include ActiveModel::Associations

  #has_many :dataset_subcategories

  attr_accessor :id, :application, :name, :subtitle, :metadata, :data_path,
                :attributes_path, :provider, :format, :layers, :connector_url, :table_name,
                :tags, :data_overwrite, :connector, :provider, :type, :legend, :status, :layers

  def initialize(data= {})
    self.attributes = data unless data == {}
  end

  def attributes
    {
        id: @id,
        name: @name,
        application: @application,
        subtitle: @subtitle,
        metadata: @metadata,
        data_path: @data_path,
        attributes_path: @attributes_path,
        provider: @provider,
        format: @format,
        layers: @layers,
        connector_url: @connector_url,
        table_name: @table_name,
        tags: @tags,
        data_overwrite: @data_overwrite,
        connector: @connector,
        type: @type,
        legend: @legend,
        status: @status,
        layers: @layers
    }
  end

  def attributes=(data)
    return unless data && (data[:attributes] || data['attributes'])
    data.symbolize_keys!
    data[:attributes].symbolize_keys!
    @id = data[:id]
    @name = data[:attributes][:name]
    @application = data[:attributes][:application]
    @subtitle = data[:attributes][:subtitle]
    @metadata = data[:attributes][:metadata]
    @data_path = data[:attributes][:data_path]
    @attributes_path = data[:attributes][:attributes_path]
    @provider = data[:attributes][:provider]
    @format = data[:attributes][:format]
    @layers = data[:attributes][:layers]
    @connector_url = data[:attributes][:connector_url]
    @table_name = data[:attributes][:table_name]
    @tags = data[:attributes][:tags]
    @data_overwrite = data[:attributes][:data_overwrite]
    @connector = data[:attributes][:connector]
    @type = data[:attributes][:type]
    @legend = data[:attributes][:legend]
    @status = data[:attributes][:status]
    @layers = []
    if data[:attributes][:layer].is_a? Array
      data[:attributes][:layer].each do |v|
        @layers << Layer.new(v)
      end
    end
  end

  def layers=(value)
    @layers = []
    value.each do |v|
      @layers << Layer.new(v)
    end
  end

  def self.datasets
    datasets = []
    DatasetService.datasets.each do |dataset|
      datasets << Dataset.new(dataset)
    end
    datasets
  end
end