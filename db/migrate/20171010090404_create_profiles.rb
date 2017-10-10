class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.string :user_id
      t.attachment :avatar

      t.timestamps
    end
    add_index :profiles, :user_id
  end
end
