class AddTranscriptionAndSidToVoicemails < ActiveRecord::Migration[5.2]
  change_table :voicemails, bulk: true do |t|
    t.string :sid
    t.text :transcription
  end
end
