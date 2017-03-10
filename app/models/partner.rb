class Partner < ApplicationRecord

  def self.published
    self.where(published: true)
  end

end
