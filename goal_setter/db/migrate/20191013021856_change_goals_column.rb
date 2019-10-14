class ChangeGoalsColumn < ActiveRecord::Migration[6.0]
  def change
    change_column :goals, :private, :boolean, default: false
    change_column :goals, :completed, :boolean, default: false
  end
end
