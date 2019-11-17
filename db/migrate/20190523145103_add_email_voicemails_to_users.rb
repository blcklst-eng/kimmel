class AddEmailVoicemailsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :email_voicemails, :boolean, default: true, null: false
  end
end
