class TemporaryContentImage < ApplicationRecord
  has_attached_file :image, styles: { cover: '1280x800>', thumb: '110x110>' }
  validates_attachment_content_type :image, content_type: %r{^image\/.*}

  def self.remove_old
    where("created_at < ?", 1.day.ago).each(&:destroy)
  end
end