class CreateVoicemails < ActiveRecord::Migration[5.2]
  def change
    create_table :voicemails do |t|
      t.references :incoming_call, foreign_key: {to_table: :calls}, null: false
      t.string :recording_url, null: false

      t.timestamps
      t.datetime :deleted_at

      t.index :deleted_at
    end
  end
end
