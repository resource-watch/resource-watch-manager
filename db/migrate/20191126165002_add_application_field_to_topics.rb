class AddApplicationFieldToTopics < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :application, :string, array: true, null: false, default: ['rw']
  end
end
