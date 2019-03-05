class RemoveColumnPlans < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :plans_id, :plans
  end
end
