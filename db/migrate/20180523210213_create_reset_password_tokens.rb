class CreateResetPasswordTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :reset_password_tokens do |t|
      t.references :user, foreign_key: true, null: false
      t.string :body, null: false
      t.boolean :used, default: false

      t.timestamps
      t.datetime :deleted_at

      t.index :deleted_at
      t.index :body, unique: true
    end
  end
end
