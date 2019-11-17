class AddConferenceSidToCalls < ActiveRecord::Migration[5.2]
  def change
    add_column :calls, :conference_sid, :string
  end
end
