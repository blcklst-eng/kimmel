class CreateRingGroupMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :ring_group_members do |t|
      t.references :user, foreign_key: true, null: false
      t.references :ring_group, foreign_key: true, null: false
      t.boolean :available, :boolean, default: false, null: false

      t.timestamps
      t.datetime :deleted_at

      t.index :deleted_at
    end
  end
end
