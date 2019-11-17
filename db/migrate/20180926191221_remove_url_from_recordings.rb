class RemoveUrlFromRecordings < ActiveRecord::Migration[5.2]
  def change
    remove_column :recordings, :url, :string, null: false
  end
end
