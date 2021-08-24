# frozen_string_literal: true
# == Schema Information
#
# Table name: partners
#
#  id                      :integer          not null, primary key
#  body                    :text
#  contact_email           :string
#  contact_name            :string
#  cover_content_type      :string
#  cover_file_name         :string
#  cover_file_size         :integer
#  cover_updated_at        :datetime
#  environment             :text             default("production"), not null
#  featured                :boolean          default(FALSE)
#  icon_content_type       :string
#  icon_file_name          :string
#  icon_file_size          :integer
#  icon_updated_at         :datetime
#  logo_content_type       :string
#  logo_file_name          :string
#  logo_file_size          :integer
#  logo_updated_at         :datetime
#  name                    :string
#  partner_type            :string
#  published               :boolean          default(FALSE)
#  slug                    :string
#  summary                 :string
#  website                 :string
#  white_logo_content_type :string
#  white_logo_file_name    :string
#  white_logo_file_size    :integer
#  white_logo_updated_at   :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_partners_on_slug  (slug)
#

# Partner serializer
class PartnerSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :summary, :body,
             :contact_email, :contact_name, :website, :featured,
             :logo, :white_logo, :cover, :icon, :partner_type, :published,
             :environment

  link(:self) { api_partner_path(object) }

  def logo
    {
      medium: object.logo.url(:medium),
      thumb: object.logo.url(:thumb),
      original: object.logo.url(:original)
    }
  end

  def white_logo
    {
      medium: object.white_logo.url(:medium),
      thumb: object.white_logo.url(:thumb),
      original: object.white_logo.url(:original)
    }
  end

  def cover
    {
      cover: object.cover.url(:large),
      original: object.cover.url(:original)
    }
  end

  def icon
    {
      icon: object.icon.url(:icon),
      original: object.icon.url(:original)
    }
  end
end
