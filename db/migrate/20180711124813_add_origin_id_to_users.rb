class AddOriginIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :origin_id, :integer
  end
end
