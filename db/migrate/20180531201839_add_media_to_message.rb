class AddMediaToMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :media, :json
  end
end
