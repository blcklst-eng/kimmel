class AddViewedToVoicemails < ActiveRecord::Migration[5.2]
  def change
    add_column :voicemails, :viewed, :boolean, default: false
  end
end
