class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :conversation, foreign_key: true, null: false
      t.string :type, null: false
      t.text :body
      t.integer :status, default: 0

      t.timestamps
      t.datetime :deleted_at

      t.index :deleted_at
    end
  end
end
