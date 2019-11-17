class RemoveTranscriptionFromRecordings < ActiveRecord::Migration[5.2]
  def change
    remove_column :recordings, :transcription, :text
  end
end
