class CreateCallTransitions < ActiveRecord::Migration[5.2]
  def change
    create_table :call_transitions do |t|
      t.string :to_state, null: false
      t.json :metadata, default: {}
      t.integer :sort_key, null: false
      t.integer :call_id, null: false
      t.boolean :most_recent, null: false

      t.timestamps null: false
      t.datetime :deleted_at

      t.index :deleted_at
    end

    add_foreign_key :call_transitions, :calls

    add_index(:call_transitions,
      [:call_id, :sort_key],
      unique: true,
      name: "index_call_transitions_parent_sort")
    add_index(:call_transitions,
      [:call_id, :most_recent],
      unique: true,
      where: "most_recent",
      name: "index_call_transitions_parent_most_recent")
  end
end
