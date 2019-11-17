class CreateRecordings < ActiveRecord::Migration[5.2]
  def change
    create_table :recordings do |t|
      t.references :call, foreign_key: true
      t.string :sid, null: false
      t.string :url, null: false
      t.integer :duration, default: 0

      t.timestamps
      t.datetime :deleted_at

      t.index :deleted_at
    end
  end
end
