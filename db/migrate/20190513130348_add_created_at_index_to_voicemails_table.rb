class AddCreatedAtIndexToVoicemailsTable < ActiveRecord::Migration[6.0]
  def change
    add_index :voicemails, :created_at
  end
end
