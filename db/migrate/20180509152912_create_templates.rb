class CreateTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :templates do |t|
      t.references :user, foreign_key: true
      t.text :body, null: false

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :templates, :deleted_at
  end
end
