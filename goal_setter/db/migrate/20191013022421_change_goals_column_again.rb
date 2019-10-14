class ChangeGoalsColumnAgain < ActiveRecord::Migration[6.0]
  def change
    change_column :goals, :private, :boolean, default: false, null: true
    change_column :goals, :completed, :boolean, default: false, null: true
  end
end
