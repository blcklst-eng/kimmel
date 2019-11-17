class CreateConversations < ActiveRecord::Migration[5.2]
  def change
    create_table :conversations do |t|
      t.references :user, foreign_key: true, null: false
      t.references :contact, foreign_key: true, null: false
      t.boolean :read, default: false
      t.datetime :last_message_at

      t.timestamps
      t.datetime :deleted_at

      t.index :last_message_at
      t.index :deleted_at
    end
  end
end
