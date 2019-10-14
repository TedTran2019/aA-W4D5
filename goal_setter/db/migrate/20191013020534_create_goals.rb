class CreateGoals < ActiveRecord::Migration[6.0]
  def change
    create_table :goals do |t|
      t.integer :owner_id, null: false
      t.boolean :private, null: false, default: false
      t.boolean :completed, null: false, default: false
      t.string :title, null: false
      t.text :details
      t.timestamps
    end

    add_index :goals, :owner_id
  end
end
