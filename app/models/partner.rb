class Partner < ApplicationRecord

  has_attached_file :logo, styles: { medium: "320x180>", thumb: "110x60>" }, default_url: "/images/:style/missing.png"
  has_attached_file :white_logo, styles: { medium: "320x180>", thumb: "110x60>" }, default_url: "/images/:style/missing.png"
  has_attached_file :cover, styles: { large: "1600x600>", medium: "320x180>" }, default_url: "/images/:style/missing.png"
  has_attached_file :icon, styles: { thumb: "25x25>" }, default_url: "/images/:style/missing.png"

  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :white_logo, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :icon, content_type: /\Aimage\/.*\z/

  def self.published
    self.where(published: true)
  end

  def self.featured(is_featured)
    self.where(featured: is_featured)
  end

end
