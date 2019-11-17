class AddAvailabilityNoteToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :availability_note, :text, null: true
  end
end
