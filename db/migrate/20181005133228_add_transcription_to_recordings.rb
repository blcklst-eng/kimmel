class AddTranscriptionToRecordings < ActiveRecord::Migration[5.2]
  def change
    add_column :recordings, :transcription, :text
  end
end
