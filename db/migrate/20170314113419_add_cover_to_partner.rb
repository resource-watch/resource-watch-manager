class AddCoverToPartner < ActiveRecord::Migration[5.0]
  def up
    add_attachment :partners, :cover
  end
end
