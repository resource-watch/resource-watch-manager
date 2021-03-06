# frozen_string_literal: true
# == Schema Information
#
# Table name: partners
#
#  id                      :integer          not null, primary key
#  name                    :string
#  slug                    :string
#  summary                 :string
#  contact_name            :string
#  contact_email           :string
#  body                    :text
#  logo_file_name          :string
#  logo_content_type       :string
#  logo_file_size          :integer
#  logo_updated_at         :datetime
#  white_logo_file_name    :string
#  white_logo_content_type :string
#  white_logo_file_size    :integer
#  white_logo_updated_at   :datetime
#  icon_file_name          :string
#  icon_content_type       :string
#  icon_file_size          :integer
#  icon_updated_at         :datetime
#  published               :boolean
#  featured                :boolean
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  cover_file_name         :string
#  cover_content_type      :string
#  cover_file_size         :integer
#  cover_updated_at        :datetime
#  website                 :string
#  partner_type            :string
#  production              :boolean          default(TRUE)
#  preproduction           :boolean          default(FALSE)
#  staging                 :boolean          default(FALSE)
#

# Partner serializer
class PartnerSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :summary, :body,
             :contact_email, :contact_name, :website, :featured,
             :logo, :white_logo, :cover, :icon, :partner_type, :published,
             :production, :preproduction, :staging

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
