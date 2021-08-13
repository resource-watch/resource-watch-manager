class AddEnvironmentToFaqs < ActiveRecord::Migration[5.1]
  def change
    add_column :faqs, :environment, :text, default: Environment::PRODUCTION
    # apply default to existing records
    execute "UPDATE faqs SET environment='#{Environment::PRODUCTION}'"
    # set NOT NULL
    change_column_null :faqs, :environment, false
  end
end
