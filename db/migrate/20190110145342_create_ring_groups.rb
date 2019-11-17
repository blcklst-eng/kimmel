class CreateRingGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :ring_groups do |t|
      t.string :name

      t.timestamps
      t.datetime :deleted_at

      t.index :deleted_at
    end
  end
end
