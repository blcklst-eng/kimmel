class DropTokens < ActiveRecord::Migration[5.2]
  def change
    drop_table :tokens do
      t.references :user, foreign_key: true, null: false
      t.string :body, null: false
      t.datetime :last_used_at, null: false

      t.timestamps
      t.datetime :deleted_at

      t.index :deleted_at
      t.index :body, unique: true
    end
  end
end
