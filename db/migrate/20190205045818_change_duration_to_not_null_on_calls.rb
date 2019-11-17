class ChangeDurationToNotNullOnCalls < ActiveRecord::Migration[5.2]
  def change
    change_column_null :calls, :duration, false
  end
end
