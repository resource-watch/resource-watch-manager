class DashboardSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :description, :body, :published
end
