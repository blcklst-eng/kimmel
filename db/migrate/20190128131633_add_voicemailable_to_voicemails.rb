class AddVoicemailableToVoicemails < ActiveRecord::Migration[5.2]
  def change
    add_reference :voicemails, :voicemailable, polymorphic: true, default: "Call", null: false
  end
end
