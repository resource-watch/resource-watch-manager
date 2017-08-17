# == Schema Information
#
# Table name: dashboards
#
#  id          :integer          not null, primary key
#  name        :string
#  slug        :string
#  description :string
#  content     :text
#  published   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  summary     :string
#  photo       :string
#

class DashboardSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :summary, :description, :content, :published, :photo

  def photo
    {
      cover: object.photo.url(:cover),
      thumb: object.photo.url(:thumb),
      original: object.photo.url(:original)
    }
  end
end
