class CreateRingGroupCalls < ActiveRecord::Migration[5.2]
  def change
    create_table :ring_group_calls do |t|
      t.references :ring_group, foreign_key: true, null: false
      t.string :from_phone_number, null: false
      t.string :from_sid, null: false

      t.timestamps
      t.datetime :deleted_at

      t.index :deleted_at
    end
  end
end
