class CreateCalls < ActiveRecord::Migration[5.2]
  def change
    create_table :calls do |t|
      t.references :user, foreign_key: true, null: false
      t.string :type, null: false
      t.string :sid
      t.integer :duration, default: 0
      t.integer :status, default: 0, null: false

      t.timestamps
      t.datetime :deleted_at

      t.index :deleted_at
      t.index :sid, unique: true
    end
  end
end
