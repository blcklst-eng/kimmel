class AddMutedToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :muted, :boolean, default: false
  end
end
