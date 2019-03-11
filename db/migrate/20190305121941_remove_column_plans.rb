class RemoveColumnPlans < ActiveRecord::Migration[5.2]
  def change
    remove_index :users, :plans_id
    remove_index :users, :plan_id
    remove_column :users, :plans_id
    remove_column :users, :plan_id
  end
end
