class AddLastContactAtToContacts < ActiveRecord::Migration[5.2]
  def change
    add_column :contacts, :last_contact_at, :datetime, null: true
    add_index :contacts, :last_contact_at
  end
end
