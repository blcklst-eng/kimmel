class CreateTagged < ActiveRecord::Migration[5.2]
  def change
    create_table :tagged do |t|
      t.references :taggable, polymorphic: true
      t.references :tag, foreign_key: true

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :tagged, :deleted_at
  end
end
