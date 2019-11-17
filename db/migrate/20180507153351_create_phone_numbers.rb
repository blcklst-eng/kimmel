class CreatePhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    create_table :phone_numbers do |t|
      t.references :user, foreign_key: true
      t.string :number, null: false

      t.timestamps
      t.datetime :deleted_at

      t.index :deleted_at
      t.index :number, unique: true
    end
  end
end
