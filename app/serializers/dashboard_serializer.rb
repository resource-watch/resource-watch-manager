class DashboardSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :summary, :description, :content, :published, :photo

  def photo
    {
      cover: object.photo.url(:cover),
      thumb: object.photo.url(:thumb)
    }
  end
end
