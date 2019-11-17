class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.references :user, foreign_key: true, null: false
      t.integer :walter_id
      t.string :first_name
      t.string :last_name
      t.string :phone_number, null: false
      t.string :email
      t.string :company
      t.string :occupation
      t.boolean :hiring_authority, default: false
      t.boolean :saved, default: false

      t.timestamps
      t.datetime :deleted_at

      t.index :first_name
      t.index :last_name
      t.index :phone_number
      t.index :deleted_at
      t.index %i[user_id phone_number], unique: true
    end
  end
end
