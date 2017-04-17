# Serializer for datasets
class DatasetSerializer < ActiveModel::Serializer
  attributes :id, :name, :layers, :provider
end
