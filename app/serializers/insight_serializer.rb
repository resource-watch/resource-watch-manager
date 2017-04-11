# == Schema Information
#
# Table name: insights
#
#  id                 :integer          not null, primary key
#  title              :string
#  summary            :text
#  description        :text
#  content            :text
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  published          :boolean
#  slug               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class InsightSerializer < ActiveModel::Serializer
  attributes :id, :title, :summary, :description, :content, :photo
end
