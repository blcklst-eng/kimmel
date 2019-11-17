class AddCreatedAtIndexToRecordingsTable < ActiveRecord::Migration[6.0]
  def change
    add_index :recordings, :created_at
  end
end
