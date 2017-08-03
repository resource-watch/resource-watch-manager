class AddPhotoToDashboards < ActiveRecord::Migration[5.1]
  def change
    add_column :dashboards, :photo, :string
  end
end
