class ChangeGoals2 < ActiveRecord::Migration[6.0]
  def change
    change_column :goals, :private, :boolean, default: false, null: false
    change_column :goals, :completed, :boolean, default: false, null: false
  end
end
