class RemoveMediaFromMessages < ActiveRecord::Migration[5.2]
  def change
    remove_column :messages, :media, :json
  end
end
