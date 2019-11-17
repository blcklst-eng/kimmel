class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :walter_id, null: true
      t.integer :intranet_id, null: true
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.boolean :active, default: true
      t.boolean :admin, default: false

      t.timestamps
      t.datetime :deleted_at

      t.index :deleted_at
      t.index :email, unique: true
    end
  end
end
