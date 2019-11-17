class CreateTransferRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :transfer_requests do |t|
      t.references :participant, index: true, foreign_key: true
      t.references :receiver, index: true, foreign_key: {to_table: :users}
      t.references :request_call, index: true, foreign_key: {to_table: :calls}
      t.references :contact, index: true, foreign_key: true
      t.string :response

      t.timestamps
      t.datetime :deleted_at

      t.index :deleted_at
    end
  end
end
