class CreateUnrecordablePhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    create_table :unrecordable_phone_numbers do |t|
      t.string :number

      t.timestamps
      t.datetime :deleted_at

      t.index :deleted_at
    end
  end
end
