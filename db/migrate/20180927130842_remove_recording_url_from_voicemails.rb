class RemoveRecordingUrlFromVoicemails < ActiveRecord::Migration[5.2]
  def change
    remove_column :voicemails, :recording_url, :string, null: false
  end
end
