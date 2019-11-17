class CreateParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :participants do |t|
      t.references :call, foreign_key: true, null: false
      t.references :contact, foreign_key: true, null: false
      t.string :sid
      t.integer :status, default: 0, null: false

      t.timestamps
      t.datetime :deleted_at

      t.index :deleted_at
    end
  end
end
