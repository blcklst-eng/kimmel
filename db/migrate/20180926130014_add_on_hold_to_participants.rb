class AddOnHoldToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :on_hold, :boolean, default: false
  end
end
