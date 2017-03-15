class PartnerSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :summary, :body,
    :contact_email, :contact_name, :website, :featured,
    :logo, :white_logo, :cover, :icon

  def logo
    {
      medium: object.logo.url(:medium),
      thumb: object.logo.url(:thumb)
    }
  end

  def white_logo
    {
      medium: object.white_logo.url(:medium),
      thumb: object.white_logo.url(:thumb)
    }
  end

  def cover
    {
      large: object.cover.url(:large),
      medium: object.cover.url(:medium)
    }
  end

  def icon
    {
      icon: object.icon.url(:icon)
    }
  end
end
