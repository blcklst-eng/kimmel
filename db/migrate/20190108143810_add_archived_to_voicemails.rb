class AddArchivedToVoicemails < ActiveRecord::Migration[5.2]
  def change
    add_column :voicemails, :archived, :boolean, default: false
  end
end
