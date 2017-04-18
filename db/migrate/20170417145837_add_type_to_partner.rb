class AddTypeToPartner < ActiveRecord::Migration[5.1]
  def change
    add_column :partners, :partner_type, :string
  end
end
