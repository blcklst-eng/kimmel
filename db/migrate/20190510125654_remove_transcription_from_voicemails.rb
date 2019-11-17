class RemoveTranscriptionFromVoicemails < ActiveRecord::Migration[5.2]
  def change
    remove_column :voicemails, :transcription, :text
  end
end
