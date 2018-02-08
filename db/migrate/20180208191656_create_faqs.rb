class CreateFaqs < ActiveRecord::Migration[5.1]
  def change
    create_table :faqs do |t|
      t.string :question, null: false
      t.text :answer, null: false
      t.float :order

      t.timestamps
    end
  end
end
