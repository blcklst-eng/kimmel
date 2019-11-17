class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :tags, :deleted_at
  end
end
