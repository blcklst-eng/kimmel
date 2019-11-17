class RemoveIncomingCallFromVoicemails < ActiveRecord::Migration[5.2]
  def change
    remove_reference :voicemails, :incoming_call, foreign_key: {to_table: :calls}, null: false
  end
end
