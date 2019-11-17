class AddQualityIssueToCalls < ActiveRecord::Migration[6.0]
  def change
    add_column :calls, :quality_issue, :boolean, default: false, null: false
  end
end
